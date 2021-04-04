class CapitalistCard < BaseCard
  def initialize
    super
    @balance = DEFAULT_BALANCE_CAPITALIST
    @type = CARD_TYPES[1]
  end
end
