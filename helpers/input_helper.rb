module InputHelper
  include OutputHelper

  def ask_greeting
    greeting_message
    gets.chomp
  end

  def ask_destroy_account
    puts 'Are you sure you want to destroy account?[y/n]'
    gets.chomp
  end
  
  def ask_age
    puts 'Enter your age'
    gets.chomp
  end

  def ask_name
    puts 'Enter your name'
    gets.chomp
  end

  def ask_login
    puts 'Enter your login'
    gets.chomp
  end

  def ask_password
    puts 'Enter your password'
    gets.chomp
  end

  def ask_amount_wiyhdraw
    puts 'Input the amount of money you want to withdraw'
    gets.chomp
  end

  def ask_recipient_card
    puts 'Enter the recipient card:'
    gets.chomp
  end

  def ask_sender_card(cards)
    cards_list_message(cards)
    gets.chomp
  end

  def ask_action(name)
    greeting_main_menu_message(name)
    gets.chomp
  end

  def ask_card_type
    create_card_message
    gets.chomp
  end

  def ask_delete_card(cards)
    delete_card_message(cards)
    gets.chomp
  end

  def ask_confirm_card_delete(card)
    puts "Are you sure you want to delete #{card.number}?[y/n]"
    gets.chomp
  end
end