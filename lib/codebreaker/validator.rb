module Validator
  def validate_guess(code)
    validate_size(code) && validate_content(code) || validate_hint_code(code)
  end

  def validate_size(code)
    code.size == 4
  end

  def validate_content(code)
    code.match(/[1-6]{4}/)
  end

  def validate_hint_code(code)
    code == 'hint'
  end
end