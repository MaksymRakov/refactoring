class MainMenuService
  include InputHelper
  include OutputHelper
  include Uploader
  extend Forwardable

  def_delegators :@card_service, :show_cards, :create_card, :destroy_card

  def initialize(accounts, current_account)
    @accounts = accounts
    @current_account = current_account
    @card_service = CardService.new(@accounts, @current_account)
  end

  def main_menu
    loop do
      command = ask_action(@current_account.name).to_sym
      COMMANDS.key?(command) ? send(COMMANDS[command]) : wrong_command_message
    end
  end

  private

  def put_money
    PutService.new(@current_account, @accounts).put_money
  end

  def withdraw_money
    WithdrawService.new(@current_account, @accounts).withdraw_money
  end

  def send_money
    SendService.new(@current_account, @accounts).send_money
  end

  def delete_account
    destroy_account(@accounts, @current_account) && exit
  end

  def programm_exit
    exit
  end

  def destroy_account
    confirm_destroy_account = ask_destroy_account
    return unless confirm_destroy_account == I18n.t(:agree)

    new_accounts = @accounts.reject { |account| account.login == @current_account.login }
    save_data(new_accounts)
  end
end
