require 'yaml'
require 'pry'

require_relative 'helpers/validate'
require_relative 'helpers/output_helper'
require_relative 'helpers/input_helper'
require_relative 'helpers/uploader.rb'
require_relative 'entities/usual_card'
require_relative 'entities/capitalist_card'
require_relative 'entities/virtual_card'
require_relative 'helpers/constants'

class Account
  include InputHelper
  include OutputHelper
  include Validate
  include Uploader

  attr_accessor :login, :name, :card, :password, :file_path

  def initialize
    @errors = []
    @card = []
  end

  def console
    answer = ask_greeting

    case answer
    when 'create' then create
    when 'load' then load
    else exit
    end
  end

  def create
    loop do
      get_user_data
      break if @errors.length == 0
      @errors.each { |error| puts error }
      @errors = []
    end

    add_account_to_data
  end

  def load
    loop do
      return create_the_first_account unless accounts.any?

      login = ask_login
      password = ask_password
      break if @current_account = check_account_credentials(login, password)

      no_account_message
    end
    main_menu
  end

  def create_the_first_account
    puts 'There is no active accounts, do you want to be the first?[y/n]'
    return create if gets.chomp == AGREE

    console
  end

  def main_menu
    loop do
      command = ask_action(@current_account.name)

      case command
      when 'SC' then show_cards
      when 'CC' then create_card
      when 'DC' then destroy_card
      when 'PM' then put_money
      when 'WM' then withdraw_money
      when 'SM' then send_money
      when 'DA'
          destroy_account
          exit
      when EXIT
          exit
          break
      else
        puts "Wrong command. Try again!\n"
      end
    end
  end

  def create_card
    loop do
      card_type = ask_card_type
      if %w[usual capitalist virtual].include?(card_type)
        case card_type
        when 'usual' then card = UsualCard.new
        when 'capitalist' then card = CapitalistCard.new
        when 'virtual' then card = VirtualCard.new
        end
        add_new_card(card)
        break
      else
        puts "Wrong card type. Try again!\n"
      end
    end
  end

  def add_new_card(card)
    @current_account.card = @current_account.card << card
    new_accounts = []
    accounts.each do |account|
      if account.login == @current_account.login
        new_accounts.push(@current_account)
      else
        new_accounts.push(account)
      end
    end
    save_data(new_accounts)
  end

  def destroy_card
    loop do
      if @current_account.card.any?
        answer = ask_delete_card(@current_account.card)
        break if answer == EXIT
        if answer.to_i.between?(1, @current_account.card.length)
          confirm_delete = ask_confirm_card_delete(@current_account.card[answer&.to_i - 1])
          return unless confirm_delete == AGREE

          @current_account.card.delete_at(answer&.to_i.to_i - 1)
          new_accounts = []
          # accounts.each { |acc| new_accounts.push(acc.login == @current_account.login ? @current_account : acc) }
          accounts.each do |account|
            if account.login == @current_account.login
              new_accounts.push(@current_account)
            else
              new_accounts.push(account)
            end
          end
          save_data(new_accounts)
          break
        else
          puts "You entered wrong number!\n"
        end
      else
        puts "There is no active cards!\n"
        break
      end
    end
  end

  def show_cards
    if @current_account.card.any?
      @current_account.card.each do |c|
        puts "- #{c[:number]}, #{c[:type]}"
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def withdraw_money
    puts 'Choose the card for withdrawing:'
    # answer, card_number, a3 = nil #answers for gets.chomp
    if @current_account.card.any?
      @current_account.card.each_with_index do |c, i|
        puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
      end
      exit_message
      loop do
        answer = gets.chomp
        break if answer == EXIT
        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
          current_card = @current_account.card[answer&.to_i.to_i - 1]
          loop do
            puts 'Input the amount of money you want to withdraw'
            card_number = gets.chomp
            if card_number&.to_i.to_i > 0
              money_left = current_card[:balance] - card_number&.to_i.to_i - withdraw_tax(current_card[:type], current_card[:balance], current_card[:number], card_number&.to_i.to_i)
              if money_left > 0
                current_card[:balance] = money_left
                @current_account.card[answer&.to_i.to_i - 1] = current_card
                new_accounts = []
                accounts.each do |ac|
                  if ac.login == @current_account.login
                    new_accounts.push(@current_account)
                  else
                    new_accounts.push(ac)
                  end
                end
                save_data(new_accounts)
                puts "Money #{card_number&.to_i.to_i} withdrawed from #{current_card[:number]}$. Money left: #{current_card[:balance]}$. Tax: #{withdraw_tax(current_card[:type], current_card[:balance], current_card[:number], card_number&.to_i.to_i)}$"
                return
              else
                puts "You don't have enough money on card for such operation"
                return
              end
            else
              puts 'You must input correct amount of $'
              return
            end
          end
        else
          puts "You entered wrong number!\n"
          return
        end
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def put_money
    puts 'Choose the card for putting:'

    if @current_account.card.any?
      @current_account.card.each_with_index do |c, i|
        puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
      end
      exit_message
      loop do
        answer = gets.chomp
        break if answer == EXIT
        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
          current_card = @current_account.card[answer&.to_i.to_i - 1]
          loop do
            puts 'Input the amount of money you want to put on your card'
            card_number = gets.chomp
            if card_number&.to_i.to_i > 0
              if put_tax(current_card[:type], current_card[:balance], current_card[:number], card_number&.to_i.to_i) >= card_number&.to_i.to_i
                puts 'Your tax is higher than input amount'
                return
              else
                new_money_amount = current_card[:balance] + card_number&.to_i.to_i - put_tax(current_card[:type], current_card[:balance], current_card[:number], card_number&.to_i.to_i)
                current_card[:balance] = new_money_amount
                @current_account.card[answer&.to_i.to_i - 1] = current_card
                new_accounts = []
                accounts.each do |account|
                  if account.login == @current_account.login
                    new_accounts.push(@current_account)
                  else
                    new_accounts.push(account)
                  end
                end
                save_data(new_accounts)
                puts "Money #{card_number&.to_i.to_i} was put on #{current_card[:number]}. Balance: #{current_card[:balance]}. Tax: #{put_tax(current_card[:type], current_card[:balance], current_card[:number], card_number&.to_i.to_i)}"
                return
              end
            else
              puts 'You must input correct amount of money'
              return
            end
          end
        else
          puts "You entered wrong number!\n"
          return
        end
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def sender_card_get
    puts 'Choose the card for sending:'
    return puts "There is no active cards!\n" unless @current_account.card.any?

    answer = ask_sender_card(@current_account.card)
    exit if answer == EXIT
    return @current_account.card[answer.to_i - 1] if answer.to_i.between?(0, @current_account.card.length)

    puts 'Choose correct card'
  end

  def recipient_card_get
    number = ask_recipient_card
    return puts 'Please, input correct number of card' unless number.length == 16

    cards = accounts.map(&:card).flatten
    return cards.select { |card| card.number == number }.first if cards.select { |card| card.number == number }.any?

    puts "There is no card with number #{number}\n"
  end
  # -----------------------------------------------------------
  def send_money
    sender_card = sender_card_get
    return unless sender_card

    recipient_card = recipient_card_get
    return unless recipient_card

    loop do
      a3 = ask_amount_wiyhdraw
      if a3&.to_i.to_i > 0
        sender_balance = sender_card.balance - a3&.to_i.to_i - sender_card.sender_tax(a3&.to_i.to_i)
        recipient_balance = recipient_card.balance + a3&.to_i.to_i - recipient_card.put_tax(a3&.to_i.to_i)

        if sender_balance < 0
          puts "You don't have enough money on card for such operation"
        elsif recipient_card.put_tax(a3&.to_i.to_i) >= a3&.to_i.to_i
          puts 'There is no enough money on sender card'
        else
          sender_card.balance = sender_balance
          @current_account.card[answer&.to_i.to_i - 1] = sender_card
          new_accounts = []
          accounts.each do |ac|
            if ac.login == @current_account.login
              new_accounts.push(@current_account)
            elsif ac.card.map { |card| card.number }.include? card_number
              recipient = ac
              new_recipient_cards = []
              recipient.card.each do |card|
                if card.number == card_number
                  card.balance = recipient_balance
                end
                new_recipient_cards.push(card)
              end
              recipient.card = new_recipient_cards
              new_accounts.push(recipient)
            end
          end
          save_data(new_accounts)
          puts "   ***   #{a3}"
          puts "   ///   Money #{a3&.to_i.to_i}$ was put on #{sender_card.number}. Balance: #{recipient_balance}. Tax: #{sender_card.put_tax(a3&.to_i.to_i)}$\n"
          puts "   ///   Money #{a3&.to_i.to_i}$ was put on #{card_number}. Balance: #{sender_balance}. Tax: #{sender_card.sender_tax(a3&.to_i.to_i)}$\n"
          break
        end
      else
        puts 'You entered wrong number!\n'
      end
    end
  end
  # --------------------------------------------------------------
  def destroy_account
    a = ask_destroy_account
    return unless a == AGREE

    new_accounts = []
    accounts.each { |account| new_accounts.push(account) unless account.login == @current_account.login }

    save_data(new_accounts)
  end

  private

  def name_input
    @name = ask_name
    @errors = validate_name(@errors, @name)
  end

  def login_input
    @login = ask_login
    @errors = validate_login(@errors, @login, accounts)
  end

  def password_input
    @password = ask_password
    @errors = validate_password(@errors, @password)
  end

  def age_input
    @age = ask_age
    if @age.to_i.is_a?(Integer) && @age.to_i.between?(23, 90)
      @age = @age.to_i
    else
      @errors.push('Your Age must be greeter then 23 and lower then 90')
    end
  end

  def accounts
    @accounts ||= load_data
  end

  def get_user_data
    name_input
    age_input
    login_input
    password_input
  end

  def add_account_to_data
    new_accounts = accounts << self
    @current_account = self
    save_data(new_accounts)
    main_menu
  end

  def check_account_credentials(login, password)
    if accounts.map { |a| { login: a.login, password: a.password } }.include?({ login: login, password: password })
      @current_account = accounts.select { |a| login == a.login }.first
    end
  end

  def withdraw_tax(type, balance, number, amount)
    if type == 'usual'
      return amount * 0.05
    elsif type == 'capitalist'
      return amount * 0.04
    elsif type == 'virtual'
      return amount * 0.88
    end
    0
  end

  def put_tax(type, balance, number, amount)
    if type == 'usual'
      return amount * 0.02
    elsif type == 'capitalist'
      return 10
    elsif type == 'virtual'
      return 1
    end
    0
  end

  def sender_tax(type, balance, number, amount)
    if type == 'usual'
      return 20
    elsif type == 'capitalist'
      return amount * 0.1
    elsif type == 'virtual'
      return 1
    end
    0
  end
end
