class WithdrawService < BaseService
  extend InputHelper
  extend OutputHelper
  extend Uploader

  class << self
    def withdraw_money(current_account, accounts)
      action_process(current_account, accounts, I18n.t(:action_withdraw))
    end

    private

    def performing_operation(accounts, current_card)
      amount = ask_withdraw_amount.to_i
      return incorrect_amount_message if amount.negative?

      money_left = current_card.balance - amount - current_card.withdraw_tax(amount)
      return no_money_message if money_left.negative?

      current_card.balance = money_left
      save_data(accounts)
      success_withdraw_message(amount, current_card)
    end
  end
end
