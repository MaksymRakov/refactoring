class SendService
  include InputHelper
  include OutputHelper
  include Uploader

  def initialize(current_account, accounts)
    @current_account = current_account
    @accounts = accounts
  end

  def send_money
    return if cards_get == false

    loop do
      @amount = ask_amount_send.to_i
      next unless check_amount

      set_balances
      next if check_balances == false

      create_new_data
      success_send_message(@amount, @recipient_card, @sender_card)
      break
    end
  end

  private

  def create_new_data
    @sender_card.balance = @sender_balance
    @recipient_card.balance = @recipient_balance
    save_data(@accounts)
  end

  def cards_get
    @sender_card = sender_card_get
    return false unless @sender_card

    @recipient_card = recipient_card_get
    false unless @recipient_card
  end

  def set_balances
    @sender_balance = @sender_card.balance - @amount - @sender_card.sender_tax(@amount)
    @recipient_balance = @recipient_card.balance + @amount - @recipient_card.put_tax(@amount)
  end

  def check_balances
    if @sender_balance.negative?
      no_money_message
      false
    elsif @recipient_card.put_tax(@amount) >= @amount
      no_money_sender_card_message
      false
    end
  end

  def check_amount
    return true if @amount.positive?

    wrong_number_message
    false
  end

  def sender_card_get
    invitation_for(I18n.t(:action_send))
    return no_cards_message unless @current_account.card.any?

    answer = ask_sender_card(@current_account.card)
    exit if answer == I18n.t(:exit)
    return @current_account.card[answer.to_i - 1] if check_card_position(answer)

    correct_card_message
  end

  def check_card_position(answer)
    answer.to_i.between?(0, @current_account.card.length)
  end

  def recipient_card_get
    number = ask_recipient_card
    return incorrect_number_message unless number.length == 16

    cards = @accounts.map(&:card).flatten
    return cards.detect { |card| card.number == number } if cards.select { |card| card.number == number }.any?

    no_card_message(number)
  end
end
