class BaseService
  include InputHelper
  include OutputHelper
  include Uploader

  def initialize(current_account, accounts)
    @current_account = current_account
    @accounts = accounts
  end

  private

  def action_process(action_name)
    invitation_for(action_name)
    return no_cards_message unless @current_account.card.any?

    cards_list_message(@current_account.card)
    return unless (answer = card_position_get)

    current_card = @current_account.card[answer.to_i - INITIAL_INDEX]
    performing_operation(current_card)
  end

  def card_position_get
    answer = gets.chomp
    return false if answer == I18n.t(:exit)

    unless answer.to_i.between?(INITIAL_INDEX, @current_account.card.length)
      wrong_number_message
      return false
    end
    answer
  end
end
