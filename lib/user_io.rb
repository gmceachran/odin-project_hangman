module UserIO
  BREAK = '--------------------------------'

  def clear
    system('clear')
  end

  def validate_input(reg, input_type)
    line = gets
    exit(0) if line.nil?

    answer = line.chomp
    until answer.match?(reg)
      puts "Invalid input: #{input_type}"
      line = gets
      exit(0) if line.nil?
      answer = line.chomp
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
        slot_number = loop do
          n = validate_input(/\A[1-3]\z/, 'enter 1, 2, or 3 to choose a slot.')
          if save_slots[n.to_i - 1] == 'empty'
            puts 'That slot is empty. Choose a slot that has a saved game.'
          else
            break n
          end
        end
        slot_number
      else 
        answer
      end
    end

    def instructions
      clear
      puts 'Welcome to Hangman!'
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
        validate_input(/\A[a-z]+\z/i, 'please enter a single letter or whole word.')
        clear

        puts 'Great job! You can also save and exit the game at any time by typing "save" and pressing "enter".'
        puts 'When you\'re ready to start, type "start".'
        validate_input(/\Astart\z/, 'please enter "start".')
      end
      system('clear')
    end
  end


  module GameActions
    include UserIO

    def slot_warning
      puts 'All slots are full, if you would like to override a slot, type the number of the slot you would like to replace.'
      puts 'If you would like to exit without saving, type "exit"'
      puts 'If you would like to continue your current game, type "con"'
      answer = validate_input(/\A([1-3]|exit|con)\z/, 'Enter 1–3 to replace that slot, "con" to continue without saving, or "exit" to quit.')
    end

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
        line = gets
        exit(0) if line.nil?
        guess = line.chomp
        g = guess.downcase
        if g != 'save' && guess.match?(/\A[a-z]+\z/i) && guess.length == 1 &&
           (incorrect_guesses.include?(g) || revealed_word.include?(g))
          puts 'You have already guessed that letter:'
          next
        end
        break if guess.match?(/\A[a-z]+\z/i)
        puts 'Invalid input: please enter a single letter or whole word.'
      end
      guess.downcase
    end
  end
end
