module InputHelper
  include OutputHelper

  def ask_greeting
    greeting_message
    gets.chomp
  end

  def ask_destroy_account
    puts I18n.t(:ask_destroy_account)
    gets.chomp
  end

  def ask_age
    puts I18n.t(:ask_age)
    gets.chomp
  end

  def ask_name
    puts I18n.t(:ask_name)
    gets.chomp
  end

  def ask_login
    puts I18n.t(:ask_login)
    gets.chomp
  end

  def ask_password
    puts I18n.t(:ask_password)
    gets.chomp
  end

  def ask_amount_wiyhdraw
    withdraw_amount_message
    gets.chomp
  end

  def ask_amount_put
    put_amount_message
    gets.chomp
  end

  def ask_amount_send
    send_amount_message
    gets.chomp
  end

  def ask_recipient_card
    puts I18n.t(:ask_recipient_card)
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
    puts I18n.t(:ask_confirm_card_delete, card_number: card.number)
    gets.chomp
  end

  def ask_withdraw_amount
    withdraw_amount_message
    gets.chomp
  end
end
