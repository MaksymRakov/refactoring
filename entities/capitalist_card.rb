class CapitalistCard < BaseCard
  DEFAULT_BALANCE = 100.0

  def initialize
    @balance = self.class::DEFAULT_BALANCE
  end
end
