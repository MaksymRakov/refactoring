class VirtualCard < BaseCard
  def initialize
    super
    @balance = DEFAULT_BALANCE_VIRTUAL
    @type = CARD_TYPES[2]
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
