COMMON_PHRASES = {
  create_first_account: "There is no active accounts, do you want to be the first?[y/n]\n",
  destroy_account: "Are you sure you want to destroy account?[y/n]\n",
  if_you_want_to_delete: 'If you want to delete:',
  choose_card: 'Choose the card for putting:',
  choose_card_withdrawing: 'Choose the card for withdrawing:',
  input_amount: 'Input the amount of money you want to put on your card',
  withdraw_amount: 'Input the amount of money you want to withdraw'
}.freeze

ERROR_PHRASES = {
  user_not_exists: 'There is no account with given credentials',
  wrong_command: 'Wrong command. Try again!',
  no_active_cards: "There is no active cards!\n",
  wrong_card_type: "Wrong card type. Try again!\n",
  wrong_number: "You entered wrong number!\n",
  correct_amount: 'You must input correct amount of money',
  tax_higher: 'Your tax is higher than input amount'
}.freeze

CARDS = {
  usual: UsualCard.new,
  capitalist: CapitalistCard.new,
  virtual: VirtualCard.new
}.freeze

OVERRIDABLE_FILENAME = 'spec/fixtures/account.yml'.freeze

CREATE_CARD_PHRASES = [
  "You could create one of 3 card types\n" \
  "- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money.\n" \
  "For creation this card - press `usual`\n" \
  "- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. \n" \
  "4$ tax on WITHDRAWING money. For creation this card - press `capitalist`\n" \
  "- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. \n" \
  "12% tax on WITHDRAWING money. For creation this card - press `virtual`\n" \
  "- For exit - press `exit`\n"
].freeze

CARD_TYPES = %w[usual capitalist virtual].freeze

MAIN_OPERATIONS_TEXTS = [
  "Welcome, John\n" \
  "If you want to:\n" \
  "- show all cards - press SC\n" \
  "- create card - press CC\n" \
  "- destroy card - press DC\n" \
  "- put money on card - press PM\n" \
  "- withdraw money on card - press WM\n" \
  "- send money to another card  - press SM\n" \
  "- destroy account - press `DA`\n" \
  "- exit from account - press `exit`\n"
].freeze

HELLO_PHRASES = [
  "Hello, we are RubyG bank!\n"\
  "- If you want to create account - press `create`\n"\
  "- If you want to load account - press `load`\n"\
  "- If you want to exit - press `exit`\n"
].freeze

ACCOUNT_VALIDATION_PHRASES = {
  name: {
    first_letter: 'Your name must not be empty and starts with first upcase letter'
  },
  login: {
    present: 'Login must present',
    longer: 'Login must be longer then 4 symbols',
    shorter: 'Login must be shorter then 20 symbols',
    exists: 'Such account is already exists'
  },
  password: {
    present: 'Password must present',
    longer: 'Password must be longer then 6 symbols',
    shorter: 'Password must be shorter then 30 symbols'
  },
  age: {
    length: 'Your Age must be greeter then 23 and lower then 90'
  }
}.freeze

ASK_PHRASES = {
  name: 'Enter your name',
  login: 'Enter your login',
  password: 'Enter your password',
  age: 'Enter your age'
}.freeze
