class UsualCard < BaseCard
  DEFAULT_BALANCE = 50.0

  def initialize
    @balance = self.class::DEFAULT_BALANCE
  end
end
