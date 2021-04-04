class UsualCard < BaseCard
  def initialize
    super
    @balance = DEFAULT_BALANCE_USUAL
    @type = CARD_TYPES[0]
  end
end
