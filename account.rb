class Account
  include InputHelper
  include OutputHelper
  include Validate
  include Uploader

  attr_accessor :login, :name, :card, :password, :file_path

  def initialize
    @errors = []
    @card = []
  end

  def console
    answer = ask_greeting

    case answer
    when 'create' then create
    when 'load' then load
    else exit
    end
  end

  def create
    loop do
      user_data_get
      break if @errors.empty?

      @errors.each { |error| puts error }
      @errors = []
    end

    add_account_to_data
  end

  def load
    loop do
      return create_the_first_account unless accounts.any?

      login = ask_login
      password = ask_password
      break if (@current_account = check_account_credentials(login, password))

      no_account_message
    end
    MainMenuService.main_menu(accounts, @current_account)
  end

  def create_the_first_account
    first_account_message
    return create if gets.chomp == I18n.t(:agree)

    console
  end

  private

  def name_input
    @name = ask_name
    @errors = validate_name(@errors, @name)
  end

  def login_input
    @login = ask_login
    @errors = validate_login(@errors, @login, accounts)
  end

  def age_input
    @age = ask_age.to_i
    @errors.push(age_limitation_message) unless @age.is_a?(Integer) && @age.between?(23, 90)
  end

  def password_input
    @password = ask_password
    @errors = validate_password(@errors, @password)
  end

  def accounts
    @accounts ||= load_data
  end

  def user_data_get
    name_input
    age_input
    login_input
    password_input
  end

  def add_account_to_data
    new_accounts = accounts << self
    @current_account = self
    save_data(new_accounts)
    MainMenuService.main_menu(accounts, @current_account)
  end

  def check_account_credentials(login, password)
    return unless accounts.map { |a| { login: a.login, password: a.password } }
                          .include?({ login: login, password: password })

    @current_account = accounts.select { |a| login == a.login }.first
  end
end
