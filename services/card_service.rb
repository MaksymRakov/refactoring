class CardService
  include InputHelper
  include OutputHelper
  include Uploader

  def initialize(accounts, current_account)
    @accounts = accounts
    @current_account = current_account
  end

  def create_card
    @current_account.card = @current_account.card << create_new_card
    save_data(@accounts)
  end

  def create_new_card
    loop do
      card_type = ask_card_type
      return Object.const_get("#{card_type.capitalize}Card").new if CARD_TYPES.include?(card_type)

      puts I18n.t(:wrong_card_type)
    end
  end

  def show_cards
    if @current_account.card.any?
      @current_account.card.each { |card| puts "- #{card.number}, #{card.type}" }
    else
      no_cards_message
    end
  end

  def destroy_card
    loop do
      card_index = destroy_card_index

      return unless card_index

      if card_index.to_i.between?(1, @current_account.card.length)
        delete_card(card_index)
        break
      end
      wrong_number_message
    end
  end

  def destroy_card_index
    no_cards_message && return unless @current_account.card.any?

    return if (card_index = ask_delete_card(@current_account.card)) == I18n.t(:exit)

    card_index
  end

  private

  def delete_card(card_number)
    return unless ask_confirm_card_delete(@current_account.card[card_number.to_i - 1]) == I18n.t(:agree)

    @current_account.card.delete_at(card_number.to_i - 1)
    save_data(@accounts)
  end
end
