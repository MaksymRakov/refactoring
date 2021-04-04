class WithdrawService < BaseService
  def withdraw_money
    action_process(I18n.t(:action_withdraw))
  end

  private

  def performing_operation(current_card)
    amount = ask_withdraw_amount.to_i
    return incorrect_amount_message if amount.negative?

    money_left = current_card.balance - amount - current_card.withdraw_tax(amount)
    return no_money_message if money_left.negative?

    current_card.balance = money_left
    save_data(@accounts)
    success_withdraw_message(amount, current_card)
  end
end
