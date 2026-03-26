require_relative 'player'

class Game
  include UserIO
  attr_reader :secret_word

  def initialize 
    @secret_word = File.readlines(File.join(__dir__, '..', 'data', 'google-10000-english-no-swears.txt')).map { |s| s.chomp }.select { |s| s.length >= 5 && s.length <= 12 }.sample
    @secret_arr = secret_word_to_arr
    @revealed_word = @secret_arr.map { '_' }
    @incorrect_guesses = 0
  end

  def play
    until @incorrect_guesses == 6 || revealed_word == @secret_word
      player_turn
    end

    if @revealed_word == @secret_word
      win
    else
      lose
    end
  end

  private

  def revealed_word
    @revealed_word.join
  end

  def evaluate(guess)
    if @secret_arr.include?(guess)
      puts "#{guess} is correct!"
      @secret_arr.each_with_index do |letter, idx|
        @revealed_word[idx] = guess if letter == guess 
      end
    else
      puts "#{guess} is incorrect."
    end
  end

  def win
  end

  def lose
  end

  def player_turn
    render_board(revealed_word)
    guess = input_guess
    evaluate(guess)
  end

  # consider just making word to arr, and have it take argument
  def secret_word_to_arr
    @secret_word.split('')
  end
end