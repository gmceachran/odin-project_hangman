require 'json'
require_relative 'user_io'
require_relative 'game'

class Menu
  include UserIO::MenuActions

  def initialize
    @save_slots = 3.times.map do |i|
      file = File.read(File.join(__dir__, '..', 'saves', "save_#{i + 1}.json"))
      file.empty? ? 'empty' : JSON.parse(file)
    end
  end

  def start_game
    if @save_slots.any? { |slot| slot != 'empty' }
      choice = choose_game(@save_slots)
      
      if choice == 'n'
        setup_game
      else
        slot = @save_slots[choice.to_i - 1]

        state = {
          secret_word: slot['secret_word'],
          revealed_word: slot['revealed_word'],
          lives: slot['lives'],
          incorrect_guesses: slot['incorrect_guesses'],
          slots: @save_slots.map { |slot| slot == 'empty' ? 'empty' : 'full' }
        }

        setup_game(state)
      end
    else
      instructions
      setup_game()
    end
  end 

  private

  def setup_game(state = {})
    state == {} ? Game.new.play : Game.new(state).play
  end

  def simplify_slots
    @save_slots.map { |slot| slot == 'empty' ? 'empty' : 'full' }
  end
end