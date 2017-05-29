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
    end

    def submit_guess(guess)
      @turns -= 1

      get_exact_matches(guess)
      get_include_matches(guess)

      return 'NO MATCH' if @marked_guess == ''
      @marked_guess.chars.sort.join
    end

    def get_hint
      @secret_code[rand(0..3)]
    end

    def game_over
      return :won if @marked_guess == '++++'
      return :lost if turns == 0
      @marked_guess = ''
      false
    end

    private

    def get_exact_matches(guess)
      guess_arr = guess.split('')
      secret_code_arr = @secret_code.split('')
      exact_match_length = guess_arr.zip(secret_code_arr).select { |guess, secret| guess == secret}.size
      exact_match_length.times { @marked_guess += '+' }
    end

    def get_include_matches(guess)
      @secret_code.each_char do |char|
        guess.slice!(char)
      end
      not_exact_match_length = @secret_code.size - @marked_guess.size - guess.size
      not_exact_match_length.times { @marked_guess += '-' }
    end
  end
end