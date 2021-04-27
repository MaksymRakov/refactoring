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

WITHDRAW_PERCENT = { usual: 5, capitalist: 4, virtual: 88 }.freeze
PUT_PERCENT = { usual: 2, capitalist: 0, virtual: 0 }.freeze
SENDER_PERCENT = { usual: 0, capitalist: 10, virtual: 0 }.freeze
WITHDRAW_FIXED = { usual: 0, capitalist: 0, virtual: 0 }.freeze
PUT_FIXED = { usual: 0, capitalist: 10, virtual: 1 }.freeze
SENDER_FIXED = { usual: 20, capitalist: 0, virtual: 1 }.freeze

CARD_NUMBER_LENGTH = 16

MIN_AGE = 23
MAX_AGE = 90
MIN_LOGIN_LENGTH = 4
MAX_LOGIN_LENGTH = 20
MIN_PASSWORD_LENGTH = 6
MAX_PASSWORD_LENGTH = 30
FULL_PERCENTS = 100
LARGEST_DIGIT_OF_NUMBER = 9
INITIAL_INDEX = 1

CREATE_COMMAND = 'create'.freeze
LOAD_COMMAND = 'load'.freeze
