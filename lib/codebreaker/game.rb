module Codebreaker
  class Game
    attr_reader :turns
    ATTEMPTS = 10
    def initialize
      @secret_code = ''
    end

    def start
      @secret_code = 4.times.map{rand(1..6)}.join
      @marked_guess = ''
      @turns = ATTEMPTS
    end

    def submit_guess(guess)
      @turns -= 1
      get_exact_matches(guess.split(''), @secret_code.split(''))
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

    def get_exact_matches(guess_arr, secret_code_arr)
      return @marked_guess = '++++' if guess_arr == secret_code_arr
      excluded_exact_match = guess_arr.zip(secret_code_arr).select { |guess, secret| guess != secret}.transpose
      @marked_guess = '+' * (4 - excluded_exact_match[0].size)
      get_include_matches(excluded_exact_match[0], excluded_exact_match[1])
    end

    def get_include_matches(guess_arr, secret_code_arr)
      secret_code_arr.each do |val|
        next if !guess_arr.include?(val) 
        guess_arr.delete_at(guess_arr.index(val))
        @marked_guess += '-'
      end
    end
  end
end