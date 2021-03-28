COMMANDS = {
  "#{I18n.t(:show_cards)}": :show_cards,
  "#{I18n.t(:create_card)}": :create_card,
  "#{I18n.t(:destroy_card)}": :destroy_card,
  "#{I18n.t(:put_money)}": :put_money,
  "#{I18n.t(:withdraw_money)}": :withdraw_money,
  "#{I18n.t(:send_money)}": :send_money,
  "#{I18n.t(:delete_account)}": :delete_account,
  "#{I18n.t(:exit)}": :programm_exit
}.freeze

CARD_TYPES = %w[usual capitalist virtual].freeze
DEFAULT_BALANCE_CAPITALIST = 100.0
DEFAULT_BALANCE_USUAL = 50.0
DEFAULT_BALANCE_VIRTUAL = 150.0
