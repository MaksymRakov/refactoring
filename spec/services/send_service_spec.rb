RSpec.describe SendService do
  subject(:current_subject) { described_class.new(current_account, accounts) }

  let(:card_one) { CARDS[:usual] }
  let(:card_two) { CARDS[:virtual] }
  let(:fake_cards) { [card_one, card_two] }
  let(:current_account) { Account.new }
  let(:accounts) { [current_account] }
  let(:exit_command) { 'exit' }

  describe '#send_money' do
    context 'without cards' do
      it 'outputs invitation string' do
        allow(current_subject).to receive(:loop)
        allow(current_subject).to receive(:recipient_card_get).and_return(true)
        expect { current_subject.send_money }.to output(/Choose the card for sending:/).to_stdout
      end

      it 'outputs no_card_message when account without cards' do
        allow(current_subject).to receive(:loop)
        expect { current_subject.send_money }.to output(/There is no active cards!/).to_stdout
      end
    end

    context 'when account with cards' do
      let(:invalid_card_position) { 7 }
      let(:wrong_number) { '1' * 16 }

      before do
        current_account.instance_variable_set(:@card, fake_cards)
      end

      it 'calls exit if command is exit' do
        allow(current_subject).to receive(:ask_sender_card).and_return(exit_command)
        expect(current_subject).to receive(:exit)

        current_subject.send_money
      end

      it 'calls #correct_card_message when card position greater cards number' do
        allow(current_subject).to receive(:ask_sender_card).and_return(invalid_card_position)
        expect(current_subject).to receive(:correct_card_message)

        current_subject.send_money
      end

      it 'calls no_card_message if recipient card namber not valid' do
        allow(current_subject).to receive(:sender_card_get).and_return(true)
        allow(current_subject).to receive(:ask_recipient_card).and_return(wrong_number)
        expect(current_subject).to receive(:no_card_message).with(wrong_number)

        current_subject.send_money
      end
    end
  end

  describe '#check_amount' do
    let(:wrong_amount) { '-2' }

    it 'calls wrong_number_message if amount less then zero' do
      allow(current_subject).to receive(:loop).and_yield
      allow(current_subject).to receive(:cards_get).and_return(true)
      allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(wrong_amount)
      allow(current_subject).to receive(:ask_amount_send).and_return(wrong_amount)
      expect(current_subject).to receive(:wrong_number_message)

      current_subject.send_money
    end
  end
end
