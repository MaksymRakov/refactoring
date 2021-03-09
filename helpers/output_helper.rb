module OutputHelper
  def greeting_message
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - press `create`'
    puts '- If you want to load account - press `load`'
    puts '- If you want to exit - press `exit`'
  end

  def greeting_main_menu_message(name)
    puts "\nWelcome, #{name}"
    puts 'If you want to:'
    puts '- show all cards - press SC'
    puts '- create card - press CC'
    puts '- destroy card - press DC'
    puts '- put money on card - press PM'
    puts '- withdraw money on card - press WM'
    puts '- send money to another card  - press SM'
    puts '- destroy account - press `DA`'
    puts '- exit from account - press `exit`'
  end

  def create_card_message
    puts 'You could create one of 3 card types'
    puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
    puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
    puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
    puts '- For exit - press `exit`'
  end

  def exit_message
    puts "press `exit` to exit\n"
  end

  def cards_list_message(cards)
    cards.each_with_index { |c, i| puts "- #{c.number}, press #{i + 1}" }
    exit_message
  end

  def delete_card_message(cards)
    puts 'If you want to delete:'
    cards_list_message(cards)
  end

  def no_account_message
    puts 'There is no account with given credentials'
  end
end
