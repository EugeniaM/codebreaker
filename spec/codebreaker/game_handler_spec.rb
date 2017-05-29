require_relative '../spec_helper'

module Codebreaker
  RSpec.describe GameHandler do
    let(:game_handler) {GameHandler.new}

    context '#get_player' do
      it "sets current player's name" do
        game_handler.get_player('John')
        expect(game_handler.player).to eq('John')
      end
    end

    context '#ask_start_game' do
      it "asks the player to start a game" do  
        allow(game_handler).to receive(:player).and_return('John')
        expected = "John, do you want to start a game? (y/n)"
        expect(game_handler.ask_start_game).to eq expected
      end
    end
    
    context '#get_decision' do
      it "returns 'true' if decision is 'y'" do
        decision = game_handler.get_decision('y')
        expect(decision).to eq true
      end
      it "returns 'false' if decision is 'n'" do
        decision = game_handler.get_decision('n')
        expect(decision).to eq false
      end
      it "returns 'nil' if decision is not 'y' or 'n'" do
        decision = game_handler.get_decision('other decision')
        expect(decision).to eq nil
      end
    end

    context '#handle_decision' do
      it "calls 'confirm_game_start' method if decision is 'nil'" do
        allow(game_handler).to receive(:confirm_game_start)
        expect(game_handler).to receive(:confirm_game_start)
        game_handler.handle_decision(nil)
      end
      it "calls 'start_game' method if decision is 'true'" do
        allow(game_handler).to receive(:start_game)
        expect(game_handler).to receive(:start_game)
        game_handler.handle_decision(true)
      end
      it "exits the program if decision is 'false'" do
        expect { game_handler.handle_decision(false) }.to raise_error(SystemExit)
      end
    end

    context '#start_game' do
      it "should call start method of game and then ask_make_move method" do
        allow(game_handler).to receive_message_chain(:game, :start)
        allow(game_handler).to receive(:make_moves)

        expect(game_handler).to receive_message_chain(:game, :start)
        expect(game_handler).to receive(:make_moves)

        game_handler.start_game
      end
    end

    context '#ask_make_move' do
      it "asks the player to make a move" do
        allow(game_handler).to receive(:player).and_return('John')
        allow(game_handler).to receive_message_chain(:game, :turns).and_return(5)
        expected = "John, try to guess a number that contains 4 digits each ranging from 1 to 6.\nYou've got 5 tries left.\nFor a hint type 'hint'"
        expect(game_handler.ask_make_move).to eq expected
      end
    end

    context 'get_guess' do
      it "should return guess code if it matches 4 digits each ranging from 1 to 6" do
        guess_code = game_handler.get_guess('1234')
        expect(guess_code).to eq('1234')
      end
      it "should return false if guess code doesn't match 4 digits each ranging from 1 to 6" do
        guess_code = game_handler.get_guess('56789')
        expect(guess_code).to be false
      end
    end

    context '#game_over_message' do
      it "returns '{current player name} won! The secret code was {game secret code}' if game shows 'won'" do
        allow(game_handler).to receive(:player).and_return('John')
        allow(game_handler).to receive_message_chain(:game, :game_over).and_return(:won)
        allow(game_handler).to receive_message_chain(:game, :instance_variable_get).with(:@secret_code).and_return('1234')
        expected = 'John won! The secret code was 1234'
        expect(game_handler.game_over_message).to eq(expected)
      end

      it "returns '{current player name} lost! The secret code was {game secret code}' if game shows 'lost'" do
        allow(game_handler).to receive(:player).and_return('John')
        allow(game_handler).to receive_message_chain(:game, :game_over).and_return(:lost)
        allow(game_handler).to receive_message_chain(:game, :instance_variable_get).with(:@secret_code).and_return('1234')
        expected = 'John lost! The secret code was 1234'
        expect(game_handler.game_over_message).to eq(expected)
      end
    end
  end
end