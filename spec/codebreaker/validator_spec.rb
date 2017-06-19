require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Validator do
    include Validator

    context '#validate_size' do
      it { expect(validate_size('1234')).to be true }
      it { expect(validate_size('123')).to be false }
    end

    context '#validate_content' do
      it { expect(validate_content('1234')).to be_kind_of(MatchData) }
      it { expect(validate_content('1278')).to be nil }
    end 

    context '#validate_hint_code' do
      it { expect(validate_hint_code('hint')).to be true}
      it { expect(validate_hint_code('1278')).to be false }
    end    
  end
end