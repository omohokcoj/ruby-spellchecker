# frozen_string_literal: true

module Spellchecker
  module Tokenizer
    NULL_POS = -1

    NULL_TOKEN = Token.new('', NULL_POS).tap do |t|
      t.next = t
      t.prev = t
    end
  end
end
