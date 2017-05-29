require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Game do
    let(:game) {Game.new}

    context '#initialize' do
      it "sets secret_code to empty string" do
        expect(game.instance_variable_get(:@secret_code)).to be_empty
      end

      it "sets default turns number to 10" do
        expect(game.instance_variable_get(:@turns)).to eq 10
      end

      it "sets marked_guess to empty string" do
        expect(game.instance_variable_get(:@marked_guess)).to be_empty
      end
    end
    
    context '#start' do

      before do
        game.instance_variable_set(:@marked_guess, '+--')
        game.instance_variable_set(:@turns, 3)
        game.start
      end
      
      it 'generates secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      
      it 'saves 4 digit secret code' do
        expect(game.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]{4}/)
      end

      it "sets marked_guess to empty string" do
        expect(game.instance_variable_get(:@marked_guess)).to eq('')
      end

      it "sets number of turns to default number 10" do
        expect(game.turns).to eq(10)
      end
    end

    context '#submit_guess' do
      before do
        game.instance_variable_set(:@secret_code, '1234')
        game.instance_variable_set(:@turns, 10)
      end

      it "should reduce number of turns by 1" do
        game.submit_guess('1111')
        expect(game.turns).to eq(9)
      end

      it "returns '+--' if guess_code is '3245' and secret_code is '1234'" do
        marked_guess = game.submit_guess('3245')
        expect(marked_guess).to eq('+--')
      end

      it "returns 'NO MATCH' if there are no matches between guess_code and secret_code" do
        marked_guess = game.submit_guess('5555')
        expect(marked_guess).to eq('NO MATCH')
      end
    end

    context '#get_exact_matches' do
      it "sets marked_guess to '++' if secret_code is '1234' and guess_code is '1554'" do
        game.instance_variable_set(:@secret_code, '1234')
        game.send(:get_exact_matches, '1554')
        expect(game.instance_variable_get(:@marked_guess)).to eq('++')
      end
    end

    context '#get_include_matches' do
      it "sets marked_guess to '--' if secret_code is '1234' and guess_code is '5162'" do
        game.instance_variable_set(:@secret_code, '1234')
        game.send(:get_include_matches, '5162')
        expect(game.instance_variable_get(:@marked_guess)).to eq('--')
      end
    end

    context '#game_over' do
      it "returns :won if marked_guess equals '++++'" do
        game.instance_variable_set(:@marked_guess, '++++')
        result = game.game_over
        expect(result).to eq :won
      end

      it "returns :lost if number of turns equals 0" do
        game.instance_variable_set(:@turns, 0)
        game.instance_variable_set(:@marked_guess, '+--')
        result = game.game_over
        expect(result).to eq :lost
      end

      it "returns false if marked_guess not equals '++++' and number of turns not equals 0" do
        game.instance_variable_set(:@turns, 3)
        game.instance_variable_set(:@marked_guess, '+--')
        result = game.game_over
        expect(result).to be false
      end

      it "sets marked_guess to empty string if marked_guess not equals '++++' and number of turns not equals 0" do
        game.instance_variable_set(:@turns, 3)
        game.instance_variable_set(:@marked_guess, '+--')
        game.game_over
        expect(game.instance_variable_get(:@marked_guess)).to eq('')
      end
    end
  end
end