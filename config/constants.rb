# AGREE = 'y'.freeze
# AMPTY_NAME = 'Your name must not be empty and starts with first upcase letter'.freeze
# ACTION_PUT = 'putting'.freeze
# ACTION_SEND = 'sending'.freeze
# ACTION_WITHDRAW = 'withdrawing'.freeze

# CREATE_CARD = 'CC'.freeze
# DELETE_ACCOUNT = 'DA'.freeze
# DESTROY_CARD = 'DC'.freeze
# PUT_MONEY = 'PM'.freeze
# SEND_MONEY = 'SM'.freeze
# SHOW_CARDS = 'SC'.freeze
# WITHDRAW_MONEY = 'WM'.freeze
# EXIT = 'exit'.freeze

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
