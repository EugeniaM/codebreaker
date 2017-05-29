module Codebreaker
  class Game
    attr_reader :turns
    def initialize
      @secret_code = ''
      @turns = 10
      @marked_guess = ''
    end

    def start
      @secret_code = 4.times.map{rand(1..6)}.join
      @marked_guess = ''
      @turns = 10
      puts @secret_code
    end

    def submit_guess(guess)
      @turns -= 1

      get_exact_matches(guess)
      get_include_matches(guess)

      return 'NO MATCH' if @marked_guess == ''
      @marked_guess.chars.sort.join
    end

    def game_over
      return :won if @marked_guess == '++++'
      return :lost if turns == 0
      @marked_guess = ''
      false
    end

    private

    def get_exact_matches(guess)
      guess.each_char.with_index do |char, i|
          @marked_guess += '+' if @secret_code[i] == char
      end
    end

    def get_include_matches(guess)
      temp_secret_code = @secret_code.clone
      guess.each_char do |char|
        temp_secret_code[temp_secret_code.index(char)] = '' if temp_secret_code.include?(char)
      end
      (@secret_code.size - @marked_guess.size - temp_secret_code.size).times { @marked_guess += '-' }
    end
  end
end