require_relative 'player'

class Game
  include UserIO
  attr_reader :secret_word, :lives, :incorrect_guesses

  def initialize 
    @secret_word = File.readlines(File.join(__dir__, '..', 'data', 'google-10000-english-no-swears.txt')).map { |s| s.chomp }.select { |s| s.length >= 5 && s.length <= 12 }.sample
    @secret_arr = secret_word_to_arr
    @revealed_word = @secret_arr.map { '_' }
    @lives = 6
    @incorrect_guesses = []
  end

  def play
    # instructions
    until @lives == 0 || revealed_word == @secret_word
      player_turn
    end
    revealed_word == @secret_word ? win : lose
  end

  private

  def revealed_word
    @revealed_word.join
  end

  def evaluate(guess)
    if guess.length > 1
      if guess == @secret_word
        puts "#{guess} is correct!"
        @revealed_word = guess.split('')
        return
      else
        puts "#{guess} is incorrect."
        @lives -= 1
        return
      end
    end
    if @secret_arr.include?(guess)
      puts "#{guess} is correct!"
      @secret_arr.each_with_index do |letter, idx|
        @revealed_word[idx] = guess if letter == guess 
      end
    else
      puts "#{guess} is incorrect."
      @incorrect_guesses << guess
      @lives -= 1
    end
  end

  def win
    render_board
    puts "You win!"
  end

  def lose
    render_board
    puts "You lose! The word was #{@secret_word}."
  end

  def player_turn
    render_board
    guess = input_guess
    if guess == 'save'
      # triger save game
    else 
      evaluate(guess)
    end
  end

  def secret_word_to_arr
    @secret_word.split('')
  end
end