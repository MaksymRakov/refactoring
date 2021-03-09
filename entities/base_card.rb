class BaseCard
  def balance
    0
  end
  private

  def generate_card_number
    Array.new(16) { rand(9) }.join
  end

  def tax(amount, percent, fixed)
    amount * percent / 100 + fixed
  end

  def withdraw_percent
    0
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
    0
  end

  def sender_fixed
    0
  end
end