RSpec.describe WithdrawService do
  subject(:current_subject) { described_class }

  describe '#withdraw_money' do
    let(:accounts) { [] }

    context 'without cards' do
      let(:current_account) { instance_double('Account', card: []) }

      it 'shows message about not active cards' do
        expect { current_subject.withdraw_money(current_account, accounts) }
          .to output(/#{ERROR_PHRASES[:no_active_cards]}/).to_stdout
      end
    end

    context 'with cards' do
      let(:current_account) { instance_double('Account', card: fake_cards) }
      let(:card_one) { CARDS[:usual] }
      let(:card_two) { CARDS[:virtual] }
      let(:fake_cards) { [card_one, card_two] }

      context 'with correct outout' do
        it do
          current_subject.instance_variable_set(:@current_account, current_subject)
          allow(current_subject).to receive_message_chain(:gets, :chomp) { 'exit' }
          expect { current_subject.withdraw_money(current_account, accounts) }
            .to output(/#{COMMON_PHRASES[:choose_card_withdrawing]}/).to_stdout
          fake_cards.each_with_index do |card, i|
            message = /- #{card.number}, #{card}, press #{i + 1}/
            expect { current_subject.withdraw_money(current_account, accounts) }.to output(message).to_stdout
          end
          current_subject.withdraw_money(current_account, accounts)
        end
      end

      context 'when exit if first gets is exit' do
        it do
          expect(current_subject).to receive_message_chain(:gets, :chomp)
          current_subject.withdraw_money(current_account, accounts)
        end
      end

      context 'with incorrect input of card number' do
        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
          expect { current_subject.withdraw_money(current_account, accounts) }
            .to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
        end

        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
          expect { current_subject.withdraw_money(current_account, accounts) }
            .to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
        end
      end

      context 'with correct input of card number' do
        let(:card_one) { CARDS[:capitalist] }
        let(:card_two) { CARDS[:capitalist] }
        let(:fake_cards) { [card_one, card_two] }
        let(:chosen_card_number) { 1 }
        let(:incorrect_money_amount) { -2 }
        let(:correct_money_amount_lower_than_tax) { 5 }
        let(:correct_money_amount_greater_than_tax) { 50 }

        before do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*commands)
        end

        context 'with correct output' do
          let(:commands) { [chosen_card_number, incorrect_money_amount] }

          it do
            expect { current_subject.withdraw_money(current_account, accounts) }
              .to output(/#{COMMON_PHRASES[:withdraw_amount]}/).to_stdout
          end
        end
      end
    end
  end
end
