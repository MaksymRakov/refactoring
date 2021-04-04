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

WITHDRAW_PERCENT = { usual: 5, capitalist: 4, virtual: 88 }.freeze
PUT_PERCENT = { usual: 2, capitalist: 0, virtual: 0 }.freeze
SENDER_PERCENT = { usual: 0, capitalist: 10, virtual: 0 }.freeze
WITHDRAW_FIXED = { usual: 0, capitalist: 0, virtual: 0 }.freeze
PUT_FIXED = { usual: 0, capitalist: 10, virtual: 1 }.freeze
SENDER_FIXED = { usual: 20, capitalist: 0, virtual: 1 }.freeze
