module UserIO

  def instructions
    system('clear')
    puts 'Welcome to Hangman!' # make fancier 
    puts '--------------------------------'
    puts 'In this game, you have six lives. If you guess a letter incorrectly, you lose a life.'
    puts 'If you guess the whole word correctly, you win the game.'
    puts 'If you lose all your lives, you lose the game.'
    puts '--------------------------------'
    puts 'In order to make a guess, type into the terminal and press "enter".'
    puts 'You can either guess a single letter, or the whole word if you think you know it,'
    puts 'But remember, if you guess a whole word incorrectly, you don\'t gain any information about the word.'
    puts 'Type a letter or whole word and press "enter" to try it out:'
    letter_input = gets.chomp
    until letter_input.match?(/\A[a-z]+\z/i)
      puts 'Invalid input: please enter a single letter or whole word.'
      letter_input = gets.chomp
    end
    system('clear')

    puts 'Great job! You can also save and exit the game at any time by typing "exit" and pressing "enter".'
    puts 'When you\'re ready to start, type "start".'
    start_input = gets.chomp
    until start_input == 'start'
      puts 'Invalid input: please enter "start".'
      start_input = gets.chomp
    end
    system('clear')
  end

  def render_board
    system('clear')
    puts 'HANGMAN'
    puts '--------------------------------'
    puts "Lives: #{lives}"
    puts "Incorrect guesses: #{incorrect_guesses.join(' ')}"
    puts "Revealed word: #{revealed_word}"
    puts '--------------------------------'
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
