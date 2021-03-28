class MainMenuService
  extend InputHelper
  extend OutputHelper
  extend Uploader

  class << self
    def main_menu(accounts, current_account)
      loop do
        command = ask_action(current_account.name).to_sym
        COMMANDS.key?(command) ? send(COMMANDS[command], accounts, current_account) : wrong_command_message
      end
    end

    private

    def show_cards(_accounts, current_account)
      CardService.show_cards(current_account)
    end

    def create_card(accounts, current_account)
      CardService.create_card(accounts, current_account)
    end

    def destroy_card(accounts, current_account)
      CardService.destroy_card(accounts, current_account)
    end

    def put_money(accounts, current_account)
      PutService.put_money(current_account, accounts)
    end

    def withdraw_money(accounts, current_account)
      WithdrawService.withdraw_money(current_account, accounts)
    end

    def send_money(accounts, current_account)
      SendService.new(current_account, accounts).send_money
    end

    def delete_account(accounts, current_account)
      destroy_account(accounts, current_account) && exit
    end

    def programm_exit
      exit
    end

    def destroy_account(accounts, current_account)
      a = ask_destroy_account
      return unless a == I18n.t(:agree)

      new_accounts = accounts.reject { |account| account.login == current_account.login }
      save_data(new_accounts)
    end
  end
end
