class VirtualCard < BaseCard
  def initialize
    super
    @balance = DEFAULT_BALANCE_VIRTUAL
    @type = CARD_TYPES[2]
  end
end
