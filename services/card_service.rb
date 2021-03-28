class CardService
  extend InputHelper
  extend OutputHelper
  extend Uploader

  class << self
    def create_card(accounts, current_account)
      current_account.card = current_account.card << create_new_card
      save_data(accounts)
    end

    def create_new_card
      loop do
        card_type = ask_card_type
        return Object.const_get("#{card_type.capitalize}Card").new if %w[usual capitalist virtual].include?(card_type)

        puts I18n.t(:wrong_card_type)
      end
    end

    def show_cards(current_account)
      if current_account.card.any?
        current_account.card.each { |card| puts "- #{card.number}, #{card}" }
      else
        no_cards_message
      end
    end

    def destroy_card(accounts, current_account)
      loop do
        card_number = destroy_card_get(current_account)

        return unless card_number

        if card_number.to_i.between?(1, current_account.card.length)
          delete_card(accounts, current_account, card_number)
          break
        end
        wrong_number_message
      end
    end

    def destroy_card_get(current_account)
      no_cards_message && return unless current_account.card.any?

      return nil if (card_number = ask_delete_card(current_account.card)) == I18n.t(:exit)

      card_number
    end

    private

    def delete_card(accounts, current_account, card_number)
      return unless ask_confirm_card_delete(current_account.card[card_number.to_i - 1]) == I18n.t(:agree)

      current_account.card.delete_at(card_number.to_i - 1)
      save_data(accounts)
    end
  end
end
