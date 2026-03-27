require 'json'
require_relative 'user_io'

class Game
  include UserIO::GameActions
  attr_reader :secret_word, :lives, :incorrect_guesses, :save_slots

  def initialize(state = {})
    @secret_word = state[:secret_word] || File.readlines(File.join(__dir__, '..', 'data', 'google-10000-english-no-swears.txt'))
                                          .map { |s| s.chomp }
                                          .select { |s| s.length >= 5 && s
                                          .length <= 12 }
                                          .sample
    @revealed_word = state[:revealed_word] || secret_arr.map { '_' }
    @lives = state[:lives] || 6
    @incorrect_guesses = state[:incorrect_guesses] || []
    @save_slots = state[:slots] || Array.new(3, 'empty')
    @loaded_from_slot = state[:loaded_from_slot]
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

    if secret_arr.include?(guess)
      puts "#{guess} is correct!"
      secret_arr.each_with_index do |letter, idx|
        @revealed_word[idx] = guess if letter == guess 
      end
    else
      puts "#{guess} is incorrect."
      @incorrect_guesses << guess
      @lives -= 1
    end
  end

  def win
    clear_loaded_save_if_any
    render_board
    puts "You win!"
  end

  def lose
    clear_loaded_save_if_any
    render_board
    puts "You lose! The word was #{@secret_word}."
  end

  def player_turn
    render_board
    guess = input_guess
    if guess == 'save'
      save_game
    else 
      evaluate(guess)
    end
  end

  def secret_arr
    @secret_word.split('')
  end

  def clear_loaded_save_if_any
    return unless @loaded_from_slot

    path = File.join(__dir__, '..', 'saves', "save_#{@loaded_from_slot}.json")
    File.write(path, '')
  end
  
  def save_and_exit(slot_number)
    game_state = {
      "secret_word": @secret_word,
      "revealed_word": @revealed_word,
      "incorrect_guesses": @incorrect_guesses,
      "lives": @lives
    }

    File.write(File.join(__dir__, '..', 'saves', "save_#{slot_number}.json"), JSON.generate(game_state))
    exit
  end

  def save_game
    slot_number = nil
    catch(:empty_slot) do 
      @save_slots.each_with_index do |slot, idx|
        slot_number = idx + 1
        throw :empty_slot if slot == 'empty'
      end
      # call function to that overrides save slot with a warning
      clear
      render_menu(@save_slots)
      slot_number = slot_warning

      if slot_number == 'exit'
        exit
      elsif slot_number == 'con'
        return
      else 
        save_and_exit(slot_number)
      end

    end

    save_and_exit(slot_number)
  end
end