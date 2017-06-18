require 'yaml'
require_relative './validator.rb'

module Codebreaker
  class GameHandler
    include Validator
    attr_reader :player, :game

    def initialize(game = Game.new)
      @game = game
    end
    
    def play
      puts "Please enter your name"
      get_player
      confirm_game_start
    end

    def confirm_game_start
      puts ask_start_game
      decision = get_decision
      handle_decision(decision)
    end

    def make_moves
      loop do
        guess_code = invite_make_guess
        case guess_code
        when false
          handle_wrong_guess
          break
        when 'hint'
          handle_hint
          break
        else display_marked_guess(guess_code)
        end
        if game.game_over
          handle_game_over
          break
        end
      end
    end

    def invite_make_guess
      puts '*****************************'
      puts ask_make_move
      puts '*****************************'
      get_guess
    end

    def handle_wrong_guess
      puts "You've entered not allowed number! It should contain 4 digits from 1 to 6."
      make_moves
    end

    def handle_hint
      hint = game.get_hint
      puts "The secret code defenitely contains #{hint}. Try to guess how many times and where it stands ;)"
      make_moves
    end

    def display_marked_guess(guess_code)
      marked_guess = game.submit_guess(guess_code)
      puts marked_guess
    end

    def handle_game_over
      puts game_over_message
      save_score
      confirm_game_start
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
      return confirm_game_start if decision.nil?
      return start_game if decision
      exit
    end

    def start_game
      game.start
      make_moves
    end

    def ask_make_move
      "#{player}, try to guess a number that contains 4 digits each ranging from 1 to 6.\nYou've got #{game.turns} tries left.\nFor a hint type 'hint'"
    end

    def get_guess(code = gets.chomp)
      return code if validate_guess(code)
      false
    end

    def game_over_message
      "#{player} #{game.game_over}! The secret code was #{game.instance_variable_get(:@secret_code)}"
    end

    def save_score
      if File.exists? ("./scores/scores.yml")
        scores = YAML.load(File.open("./scores/scores.yml"))
      else
        scores = []
        File.new("./scores/scores.yml", "w")
      end

      scores.push({name: player, turns: (10 - game.turns), status: game.game_over, date: Time.now.strftime("%d/%m/%Y %H:%M")})
      File.open("./scores/scores.yml", "w") {|f| f.write(scores.to_yaml) }
    end
  end
end