RSpec.describe CardService do
  subject(:current_subject) { described_class.new(accounts, current_account) }

  let(:card_one) { CARDS[:usual] }
  let(:card_two) { CARDS[:virtual] }
  let(:fake_cards) { [card_one, card_two] }
  let(:current_account) { Account.new }
  let(:accounts) { [current_account] }

  before do
    stub_const('Uploader::FILE_PATH', OVERRIDABLE_FILENAME)
    current_account.instance_variable_set(:@card, fake_cards)
  end

  describe '#destroy_card' do
    let(:accounts) { [] }

    context 'without cards' do
      let(:current_account) { instance_double('Account', card: []) }

      it 'shows message about not active cards' do
        allow(current_subject).to receive_message_chain(:gets, :chomp)
        expect { current_subject.destroy_card }
          .to output(/#{ERROR_PHRASES[:no_active_cards]}/).to_stdout
      end
    end

    context 'with cards' do
      let(:current_account) { instance_double('Account', card: fake_cards) }

      context 'with correct outout' do
        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp) { 'exit' }
          expect { current_subject.destroy_card }
            .to output(/#{COMMON_PHRASES[:if_you_want_to_delete]}/).to_stdout
          fake_cards.each_with_index do |card, i|
            message = /- #{card.number}, #{card}, press #{i + 1}/
            expect { current_subject.destroy_card }.to output(message).to_stdout
          end
          current_subject.destroy_card
        end
      end

      context 'when exit if first gets is exit' do
        it do
          expect(current_subject).to receive_message_chain(:gets, :chomp)
          current_subject.destroy_card
        end
      end

      context 'with incorrect input of card number' do
        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
          expect { current_subject.destroy_card }
            .to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
        end

        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
          expect { current_subject.destroy_card }
            .to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
        end
      end

      context 'with correct input of card number' do
        let(:accept_for_deleting) { 'y' }
        let(:reject_for_deleting) { 'asdf' }
        let(:deletable_card_number) { 1 }
        let(:current_account) { Account.new }
        let(:accounts) { [current_account] }

        before do
          current_account.instance_variable_set(:@card, fake_cards)
        end

        after do
          File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
        end

        it 'accept deleting' do
          commands = [deletable_card_number, accept_for_deleting]
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*commands)

          expect { current_subject.destroy_card }.to change { current_account.card.size }
            .by(-1)

          expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
          file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
          expect(file_accounts.first.card).not_to include(card_one)
        end

        it 'decline deleting' do
          commands = [deletable_card_number, reject_for_deleting]
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*commands)

          expect { current_subject.destroy_card }.not_to change(current_account.card, :size)
        end
      end
    end
  end

  describe '#create_card' do
    let(:current_account) { Account.new }
    let(:accounts) { [current_account] }

    context 'with correct outout' do
      it do
        CREATE_CARD_PHRASES.each { |phrase| expect(current_subject).to receive(:puts).with(phrase) }
        allow(File).to receive(:open)
        allow(current_subject).to receive_message_chain(:gets, :chomp) { 'usual' }

        current_subject.create_card
      end
    end

    context 'when correct card choose' do
      let(:account) { Account.new }
      let(:accounts) { [account] }
      let(:current_subject) { described_class.new(accounts, account) }

      before do
        account.instance_variable_set(:@card, [])
      end

      after do
        File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
      end

      CARD_TYPES.each do |card_type|
        it 'create card with type' do
          allow(current_subject).to receive_message_chain(:gets, :chomp) { card_type.to_s }

          current_subject.create_card

          expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
          file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
          expect(file_accounts.first.card.first).to be_instance_of(Object.const_get("#{card_type.capitalize}Card"))
          expect(file_accounts.first.card.first.balance)
            .to eq(Object.const_get("#{card_type.capitalize}Card").new.balance)
          expect(file_accounts.first.card.first.number.length).to be CARD_NUMBER_LENGTH
        end
      end
    end

    context 'when incorrect card choose' do
      it do
        allow(File).to receive(:open)
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return('test', 'usual')

        expect { current_subject.create_card }
          .to output(/#{ERROR_PHRASES[:wrong_card_type]}/).to_stdout
      end
    end
  end

  describe '#show_cards' do
    it 'display cards if there are any' do
      fake_cards.each { |card| expect(current_subject).to receive(:puts).with("- #{card.number}, #{card.type}") }
      current_subject.show_cards
    end

    it 'outputs error if there are no active cards' do
      current_account.instance_variable_set(:@card, [])
      expect(current_subject).to receive(:puts).with(ERROR_PHRASES[:no_active_cards])
      current_subject.show_cards
    end
  end
end
