COMMON_PHRASES = {
  create_first_account: I18n.t(:first_account_message),
  destroy_account: I18n.t(:ask_destroy_account),
  if_you_want_to_delete: I18n.t(:proposal_to_delete),
  choose_card: I18n.t(:invitation_for, action_name: 'putting'),
  choose_card_withdrawing: I18n.t(:invitation_for, action_name: 'withdrawing'),
  input_amount: I18n.t(:put_amount_message),
  withdraw_amount: I18n.t(:withdraw_amount_message)
}.freeze

ERROR_PHRASES = {
  user_not_exists: I18n.t(:no_account_message),
  wrong_command: I18n.t(:wrong_command_message),
  no_active_cards: I18n.t(:no_cards_message),
  wrong_card_type: I18n.t(:wrong_card_type),
  wrong_number: I18n.t(:wrong_number_message),
  correct_amount: I18n.t(:incorrect_amount_message),
  tax_higher: I18n.t(:big_tax_message)
}.freeze

CARDS = {
  usual: UsualCard.new,
  capitalist: CapitalistCard.new,
  virtual: VirtualCard.new
}.freeze

OVERRIDABLE_FILENAME = 'spec/fixtures/account.yml'.freeze

CREATE_CARD_PHRASES = [
  I18n.t(:create_card_message)
].freeze

CARD_TYPES = %w[usual capitalist virtual].freeze

MAIN_OPERATIONS_TEXTS = [
  I18n.t(:greeting_main_menu_message, name: 'John')
].freeze

HELLO_PHRASES = [
  I18n.t(:greeting_message)
].freeze

ACCOUNT_VALIDATION_PHRASES = {
  name: {
    first_letter: I18n.t(:ampty_name)
  },
  login: {
    present: I18n.t(:login_present),
    longer: I18n.t(:min_login_lemngth),
    shorter: I18n.t(:max_login_lemngth),
    exists: I18n.t(:account_exist)
  },
  password: {
    present: I18n.t(:password_present),
    longer: I18n.t(:min_password_lemngth),
    shorter: I18n.t(:max_password_lemngth)
  },
  age: {
    length: I18n.t(:age_limitation_message)
  }
}.freeze

ASK_PHRASES = {
  name: I18n.t(:ask_name),
  login: I18n.t(:ask_login),
  password: I18n.t(:ask_password),
  age: I18n.t(:ask_age)
}.freeze
