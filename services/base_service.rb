class BaseService
  class << self
    private

    def action_process(current_account, accounts, action_name)
      invitation_for(action_name)
      return no_cards_message unless current_account.card.any?

      cards_list_message(current_account.card)
      return unless (answer = get_card_number(current_account))

      current_card = current_account.card[answer.to_i - 1]
      performing_operation(accounts, current_card)
    end

    def get_card_number(current_account)
      answer = gets.chomp
      return false if answer == I18n.t(:exit)

      unless answer.to_i.between?(1, current_account.card.length)
        wrong_number_message
        return false
      end
      answer
    end
  end
end
