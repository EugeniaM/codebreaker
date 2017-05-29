module Codebreaker
  class GameHandler
    attr_reader :player, :game

    def initialize(game = Game.new)
      @game = game
    end

    def get_player(name = gets.chomp)
      @player = name
    end

    def ask_start_game
      "#{player}, do you want to start a game? (y/n)"
    end

    def get_decision(decision = gets.chomp)
      return true if decision == 'y'
      return false if decision == 'n'
      nil
    end

    def handle_decision(decision)
      return confirm_game_start if decision == nil
      return start_game if decision
      exit
    end

    def confirm_game_start
      puts ask_start_game
      decision = get_decision
      handle_decision(decision)
    end

    def start_game
      game.start
      make_moves
    end

    def make_moves
      while true
        puts ask_make_move
        guess_code = get_guess
        unless guess_code
          puts "You've entered not allowed number! It should contain 4 digits from 1 to 6."
          make_moves
          return
        end
        marked_guess = game.submit_guess(guess_code)
        puts marked_guess
        if game.game_over
          puts game_over_message
          confirm_game_start
          return
        end
      end
    end

    def ask_make_move
      "#{player}, try to guess a number that contains 4 digits each ranging from 1 to 6.\nYou've got #{game.turns} tries left.\nFor a hint type 'hint'"
    end

    def get_guess(code = gets.chomp)
      return code if code.size == 4 && code.match(/[1-6]{4}/)
      # hint case
      false
    end

    def game_over_message
      return "#{player} won! The secret code was #{game.instance_variable_get(:@secret_code)}" if game.game_over == :won
      return "#{player} lost! The secret code was #{game.instance_variable_get(:@secret_code)}" if game.game_over == :lost
    end

    def play
      puts "Please enter your name"
      get_player
      confirm_game_start
    end
  end
end