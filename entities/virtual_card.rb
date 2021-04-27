class VirtualCard < BaseCard
  DEFAULT_BALANCE = 150.0

  def initialize
    @balance = self.class::DEFAULT_BALANCE
  end
end
