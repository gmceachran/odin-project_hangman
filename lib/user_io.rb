module UserIO
  BREAK = '--------------------------------'

  def clear
    system('clear')
  end

  def validate_input(reg, input_type)
    answer = gets.chomp
    until answer.match?(reg)
      puts "Invalid input: #{input_type}"
      answer = gets.chomp
    end
    answer
  end

  def render_menu(save_slots)
    save_slots.each_with_index do |slot, idx|
      puts "Slot #{idx + 1}:"
      if slot == 'empty'
        puts 
        puts 'empty'
        puts BREAK
      else 
        puts "Lives: #{slot["lives"]}"
        puts "Revealed word: #{slot["revealed_word"].join}"
        puts BREAK
      end
    end
  end
  

  module MenuActions
    include UserIO

    def choose_game(save_slots)
      clear
      puts 'Would you like to load an existing game? (y/n)'
      answer = validate_input(/\A[yn]\z/, 'answer should be "y" or "n"')
  
      if answer == 'y'
        clear
        render_menu(save_slots)
        
        puts 'Enter the slot number of the game you would like to continue:'
        slot_number = validate_input(/\A[1-3]\z/, 'enter 1, 2, or 3 to choose a slot.')
      else 
        answer
      end
    end

    def instructions
      clear
      puts 'Welcome to Hangman!' # make fancier 
      puts BREAK
      puts 'Would you like a brief tutorial? (y/n)'

      if validate_input(/\A[yn]\z/, 'answer should be "y" or "n"') == 'y'
        clear
        puts 'In this game, you have six lives. If you guess a letter incorrectly, you lose a life.'
        puts 'If you guess the whole word correctly, you win the game.'
        puts 'If you lose all your lives, you lose the game.'
        puts BREAK
        puts 'In order to make a guess, type into the terminal and press "enter".'
        puts 'You can either guess a single letter, or the whole word if you think you know it,'
        puts 'But remember, if you guess a whole word incorrectly, you don\'t gain any information about the word.'
        puts 'Type a letter or whole word and press "enter" to try it out:'
        letter_input = validate_input(/\A[a-z]+\z/i, 'please enter a single letter or whole word.')
        clear
    
        puts 'Great job! You can also save and exit the game at any time by typing "exit" and pressing "enter".'
        puts 'When you\'re ready to start, type "start".'
        start_input = validate_input(/\Astart\z/, 'please enter "start".')
      end
      system('clear')
    end
  end


  module GameActions
    include UserIO

    def render_board
      system('clear')
      puts 'HANGMAN'
      puts BREAK
      puts "Lives: #{lives}"
      puts "Incorrect guesses: #{incorrect_guesses.join(' ')}"
      puts "Revealed word: #{revealed_word}"
      puts BREAK
    end
  
    def input_guess
      print 'Guess a letter or word: ' 
      guess = ''
      loop do
        guess = gets.chomp
        if guess.length == 1 && (incorrect_guesses.include?(guess) || revealed_word.include?(guess))
          puts 'You have already guessed that letter:'
          next
        end
        break if guess.match?(/\A[a-z]+\z/i)
        puts 'Invalid input: please enter a single letter or whole word.'
      end
      guess
    end
  end
end
