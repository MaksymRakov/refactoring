class PutService < BaseService
  extend InputHelper
  extend OutputHelper
  extend Uploader

  class << self
    def put_money(current_account, accounts)
      action_process(current_account, accounts, I18n.t(:action_put))
    end

    private

    def performing_operation(accounts, current_card)
      amount = ask_amount_put.to_i
      return incorrect_amount_message unless amount.positive?

      return big_tax_message if current_card.put_tax(amount) >= amount

      new_money_amount = current_card.balance + amount - current_card.put_tax(amount)
      current_card.balance = new_money_amount
      save_data(accounts)
      success_put_message(amount, current_card)
    end
  end
end
