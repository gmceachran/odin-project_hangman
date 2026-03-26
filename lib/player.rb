module UserIO
  def render_board(revealed_word)
    puts revealed_word
  end

  def input_guess
    puts 'Guess a letter:'
    guess = ''
    loop do
      guess = gets.chomp
      break if guess.match?(/\A[a-z]\z/i)
      puts 'Invalid input: please enter a single letter.'
    end
    guess
  end
end
