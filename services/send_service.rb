class SendService < BaseService
  def send_money
    return unless cards_get

    loop do
      @amount = ask_amount_send.to_i
      next unless check_amount

      set_balances
      next unless check_balances

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
    return unless @sender_card

    @recipient_card = recipient_card_get
    return unless @recipient_card

    true
  end

  def set_balances
    @sender_balance = @sender_card.balance - @amount - @sender_card.sender_tax(@amount)
    @recipient_balance = @recipient_card.balance + @amount - @recipient_card.put_tax(@amount)
  end

  def check_balances
    return no_money_message if @sender_balance.negative?

    return no_money_sender_card_message if @recipient_card.put_tax(@amount) >= @amount

    true
  end

  def check_amount
    return true if @amount.positive?

    wrong_number_message
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
