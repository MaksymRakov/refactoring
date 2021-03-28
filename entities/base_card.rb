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
    raise NotImplementedError
  end

  def put_percent
    raise NotImplementedError
  end

  def sender_percent
    raise NotImplementedError
  end

  def withdraw_fixed
    raise NotImplementedError
  end

  def put_fixed
    raise NotImplementedError
  end

  def sender_fixed
    raise NotImplementedError
  end
end
