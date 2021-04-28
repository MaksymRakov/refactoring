RSpec.describe MainMenuService do
  subject(:current_subject) { described_class.new(accounts, current_account) }

  let(:card_one) { CARDS[:usual] }
  let(:card_two) { CARDS[:virtual] }
  let(:fake_cards) { [card_one, card_two] }
  let(:current_account) { Account.new }
  let(:accounts) { [current_account] }
  let(:name) { 'John' }

  before do
    stub_const('Uploader::FILE_PATH', OVERRIDABLE_FILENAME)
    current_account.instance_variable_set(:@card, fake_cards)
    current_account.instance_variable_set(:@name, name)
    allow(current_subject).to receive(:loop).and_yield
  end

  describe '#main_menu' do
    let(:commands) do
      {
        'SC' => :show_cards,
        'CC' => :create_card,
        'DC' => :destroy_card,
        'PM' => :put_money,
        'WM' => :withdraw_money,
        'SM' => :send_money,
        'DA' => :delete_account,
        'exit' => :programm_exit
      }
    end

    context 'with correct outout' do
      it do
        allow(current_subject).to receive(:show_cards)
        allow(current_subject).to receive(:exit)
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
        expect { current_subject.main_menu }.to output(/Welcome, #{name}/).to_stdout
        MAIN_OPERATIONS_TEXTS.each do |text|
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
          expect { current_subject.main_menu }.to output(text).to_stdout
        end
      end
    end

    context 'when commands used' do
      let(:undefined_command) { 'undefined' }

      it 'calls specific methods on predefined commands' do
        allow(current_subject).to receive(:exit)

        commands.each do |command, method_name|
          allow(current_subject).to receive(exit)
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(command, 'exit')
          expect(current_subject).to receive(method_name)
          current_subject.main_menu
        end
      end

      it 'outputs incorrect message on undefined command' do
        allow(current_subject).to receive(:programm_exit)
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(undefined_command, 'exit')
        expect { current_subject.main_menu }.to output(/#{ERROR_PHRASES[:wrong_command]}/)
          .to_stdout
      end
    end
  end

  describe '#destroy_account' do
    let(:cancel_input) { 'sdfsdfs' }
    let(:success_input) { 'y' }
    let(:correct_login) { 'test' }
    let(:fake_login) { 'test1' }
    let(:fake_login2) { 'test2' }
    let(:correct_account) { instance_double('Account', login: correct_login) }
    let(:fake_account) { instance_double('Account', login: fake_login) }
    let(:fake_account2) { instance_double('Account', login: fake_login2) }
    let(:accounts) { [correct_account, fake_account, fake_account2] }

    after do
      File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
    end

    it 'with correct outout' do
      expect(current_subject).to receive_message_chain(:gets, :chomp)
      expect { current_subject.destroy_account }.to output(COMMON_PHRASES[:destroy_account])
        .to_stdout
    end

    context 'when deleting' do
      it 'deletes account if user inputs is y' do
        allow(current_subject).to receive_message_chain(:gets, :chomp) { success_input }
        allow(current_subject).to receive(:accounts) { accounts }

        current_subject.destroy_account

        expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
        file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
        expect(file_accounts).to be_a Array
        expect(file_accounts.size).to be 2
      end

      it 'doesnt delete account' do
        allow(current_subject).to receive_message_chain(:gets, :chomp) { cancel_input }

        current_subject.destroy_account

        expect(File.exist?(OVERRIDABLE_FILENAME)).to be false
      end
    end
  end
end
