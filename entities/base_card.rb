class BaseCard
  attr_accessor :balance
  attr_reader :type, :number

  def initialize
    @number = generate_card_number
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

  private

  def withdraw_percent
    WITHDRAW_PERCENT[@type.to_sym]
  end

  def put_percent
    PUT_PERCENT[@type.to_sym]
  end

  def sender_percent
    SENDER_PERCENT[@type.to_sym]
  end

  def withdraw_fixed
    WITHDRAW_FIXED[@type.to_sym]
  end

  def put_fixed
    PUT_FIXED[@type.to_sym]
  end

  def sender_fixed
    SENDER_FIXED[@type.to_sym]
  end

  def generate_card_number
    Array.new(16) { rand(9) }.join
  end

  def tax(amount, percent, fixed)
    amount * percent / 100 + fixed
  end
end
