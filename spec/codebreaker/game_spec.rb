require_relative '../spec_helper'
require_relative '../../test_data/test_data'

module Codebreaker
  RSpec.describe Game do
    subject(:game) {Game.new}

    context '#initialize' do
      it "sets secret_code to empty string" do
        expect(game.instance_variable_get(:@secret_code)).to be_empty
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
        game.instance_variable_set(:@marked_guess, '')
      end

      it "should reduce number of turns by 1" do
        game.submit_guess('1111')
        expect(game.turns).to eq(9)
      end

      data = CodebreakerData::data
      data.each do |dataSet|
        it "returns #{dataSet[2]} if guess_code is #{dataSet[1]} and secret_code is #{dataSet[0]}" do
          game.instance_variable_set(:@secret_code, dataSet[0])
          marked_guess = game.submit_guess(dataSet[1])
          expect(marked_guess).to eq(dataSet[2])
        end
      end

      it "returns 'NO MATCH' if there are no matches between guess_code and secret_code" do
        marked_guess = game.submit_guess('5555')
        expect(marked_guess).to eq('NO MATCH')
      end
    end

    context '#get_hint' do
      it "returns 3 if secret_code is '1234' and randomly generated number is 2" do
        allow_any_instance_of(Kernel).to receive(:rand).with(0..3).and_return 2
        game.instance_variable_set(:@secret_code, '1234')
        result = game.get_hint
        expect(result).to eq '3'
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