require_relative 'base_card'

class VirtualCard < BaseCard
  attr_accessor :balance

  def initialize
    @balance = 150.0
  end

  def number
    @number ||= generate_card_number
  end

  def withdraw_tax(amount)
    tax(amount, withdraw_percent, withdraw_fixed)
  end

  def put_tax(amount)
    tax(amount, put_percent, put_fixed)
  end

  def sender_tax(amount)
    tax(amount, sender_percent, sender_fixed)
  end

  # def balance
  #   150.0
  # end

  private

  def withdraw_percent
    88
  end

  def put_percent
    0
  end

  def sender_percent
    0
  end

  def withdraw_fixed
    0
  end

  def put_fixed
    1
  end

  def sender_fixed
    1
  end
end