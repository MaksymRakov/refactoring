module OutputHelper
  def greeting_message
    puts I18n.t(:greeting_message)
  end

  def greeting_main_menu_message(name)
    # puts I18n.t(:welcome, name: name)
    puts I18n.t(:greeting_main_menu_message, name: name)
  end

  def create_card_message
    puts I18n.t(:create_card_message)
  end

  def cards_list_message(cards)
    cards.each_with_index { |card, i| puts "- #{card.number}, #{card}, #{I18n.t(:press)} #{i + 1}" }
    puts I18n.t(:press_exit)
  end

  def delete_card_message(cards)
    puts I18n.t(:proposal_to_delete)
    cards_list_message(cards)
  end

  def no_account_message
    puts I18n.t(:no_account_message)
  end

  def no_cards_message
    puts I18n.t(:no_cards_message)
  end

  def wrong_number_message
    puts I18n.t(:wrong_number_message)
  end

  def withdraw_amount_message
    puts I18n.t(:withdraw_amount_message)
  end

  def put_amount_message
    puts I18n.t(:put_amount_message)
  end

  def send_amount_message
    puts I18n.t(:send_amount_message)
  end

  def no_money_message
    puts I18n.t(:no_money_message)
  end

  def no_money_sender_card_message
    puts I18n.t(:no_money_sender_card_message)
  end

  def incorrect_amount_message
    puts I18n.t(:incorrect_amount_message)
  end

  def invitation_for(action_name)
    puts I18n.t(:invitation_for, action_name: action_name)
  end

  def big_tax_message
    puts I18n.t(:big_tax_message)
  end

  def correct_card_message
    puts I18n.t(:correct_card_message)
  end

  def incorrect_number_message
    puts I18n.t(:incorrect_number_message)
  end

  def no_card_message(number)
    puts I18n.t(:no_card_message, number: number)
  end

  def success_send_message(amount, recipient_card, sender_card)
    puts I18n.t(:success_send_message, amount: amount,
                                       number: recipient_card.number,
                                       balance: sender_card.balance,
                                       tax: sender_card.sender_tax(amount))
  end

  def success_withdraw_message(amount, current_card)
    puts I18n.t(:success_withdraw_message, amount: amount,
                                           number: current_card.number,
                                           balance: current_card.balance,
                                           tax: current_card.withdraw_tax(amount))
  end

  def success_put_message(amount, current_card)
    puts I18n.t(:success_withdraw_message, amount: amount,
                                           number: current_card.number,
                                           balance: current_card.balance,
                                           tax: current_card.put_tax(amount))
  end

  def age_limitation_message
    I18n.t(:age_limitation_message)
  end

  def first_account_message
    puts I18n.t(:first_account_message)
  end

  def wrong_command_message
    puts I18n.t(:wrong_command_message)
  end
end
