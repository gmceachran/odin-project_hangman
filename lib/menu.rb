require 'json'
require_relative 'user_io'
require_relative 'game'

class Menu
  include UserIO::MenuActions

  def initialize
    @save_slots = 3.times.map do |i|
      path = File.join(__dir__, '..', 'saves', "save_#{i + 1}.json")
      next 'empty' unless File.exist?(path)

      contents = File.read(path)
      next 'empty' if contents.strip.empty?

      JSON.parse(contents)
    rescue JSON::ParserError
      'empty'
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
          loaded_from_slot: choice.to_i
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
    Game.new(state.merge(slots: @save_slots)).play
  end
end