RSpec.describe PutService do
  subject(:current_subject) { described_class }

  before do
    stub_const('Uploader::FILE_PATH', OVERRIDABLE_FILENAME)
  end

  describe '#put_money' do
    let(:accounts) { [] }
    let(:current_account) { instance_double('Account', card: []) }

    context 'without cards' do
      it 'shows message about not active cards' do
        expect { current_subject.put_money(current_account, accounts) }.to output(/#{ERROR_PHRASES[:no_active_cards]}/)
          .to_stdout
      end
    end

    context 'with cards' do
      let(:card_one) { CARDS[:usual] }
      let(:card_two) { CARDS[:virtual] }
      let(:fake_cards) { [card_one, card_two] }
      let(:current_account) { instance_double('Account', card: fake_cards) }

      context 'with correct outout' do
        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp) { 'exit' }
          expect { current_subject.put_money(current_account, accounts) }.to output(/#{COMMON_PHRASES[:choose_card]}/)
            .to_stdout
          fake_cards.each_with_index do |card, i|
            message = /- #{card.number}, #{card}, press #{i + 1}/
            expect { current_subject.put_money(current_account, accounts) }.to output(message).to_stdout
          end
          current_subject.put_money(current_account, accounts)
        end
      end

      context 'when exit if first gets is exit' do
        it do
          expect(current_subject).to receive_message_chain(:gets, :chomp)
          current_subject.put_money(current_account, accounts)
        end
      end

      context 'with incorrect input of card number' do
        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
          expect { current_subject.put_money(current_account, accounts) }.to output(/#{ERROR_PHRASES[:wrong_number]}/)
            .to_stdout
        end

        it do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
          expect { current_subject.put_money(current_account, accounts) }.to output(/#{ERROR_PHRASES[:wrong_number]}/)
            .to_stdout
        end
      end

      context 'with correct input of card number' do
        let(:card_one) { CARDS[:capitalist] }
        let(:card_two) { CARDS[:capitalist] }
        let(:fake_cards) { [card_one, card_two] }
        let(:chosen_card_number) { 1 }
        let(:incorrect_money_amount) { -2 }
        let(:default_balance) { 50.0 }
        let(:correct_money_amount_lower_than_tax) { 5 }
        let(:correct_money_amount_greater_than_tax) { 50 }

        before do
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*commands)
        end

        context 'with correct output' do
          let(:commands) { [chosen_card_number, incorrect_money_amount] }

          it do
            expect { current_subject.put_money(current_account, accounts) }
              .to output(/#{COMMON_PHRASES[:input_amount]}/).to_stdout
          end
        end

        context 'with amount lower then 0' do
          let(:commands) { [chosen_card_number, incorrect_money_amount] }

          it do
            expect { current_subject.put_money(current_account, accounts) }
              .to output(/#{ERROR_PHRASES[:correct_amount]}/).to_stdout
          end
        end

        context 'with amount greater then 0' do
          context 'with tax greater than amount' do
            let(:commands) { [chosen_card_number, correct_money_amount_lower_than_tax] }

            it do
              expect { current_subject.put_money(current_account, accounts) }.to output(/#{ERROR_PHRASES[:tax_higher]}/)
                .to_stdout
            end
          end

          context 'with tax lower than amount' do
            let(:custom_cards) do
              [
                CARDS[:usual],
                CARDS[:capitalist],
                CARDS[:virtual]
              ]
            end
            let(:current_account) { Account.new }
            let(:accounts) { [current_account] }

            before do
              current_account.instance_variable_set(:@card, custom_cards)
            end

            after do
              File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
            end

            it do
              custom_cards.each_with_index do |custom_card, i|
                commands = [i + 1, correct_money_amount_greater_than_tax]
                current_account = instance_double('Account', card: custom_cards)
                allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*commands)
                expected_string = "Money #{correct_money_amount_greater_than_tax} was put on #{custom_card.number}. " \
                "Balance: #{new_balance}. Tax: #{custom_card.put_tax(correct_money_amount_greater_than_tax)}"
                new_balance = custom_card.balance + correct_money_amount_greater_than_tax -
                              custom_card.put_tax(correct_money_amount_greater_than_tax)
                expect { current_subject.put_money(current_account, accounts) }.to output(expected_string).to_stdout

                expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
                file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
                expect(file_accounts.first.card[i].balance).to eq(new_balance)
              end
            end
          end
        end
      end
    end
  end
end
