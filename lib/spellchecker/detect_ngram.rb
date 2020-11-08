# frozen_string_literal: true

module Spellchecker
  module DetectNgram
    NGRAM_RANGE = (1..4).freeze
    SEPARATOR_REGEXP = /[;,\n.]/.freeze

    module_function

    # @param token [Spellchecker::Tokenizer::Token]
    # @return [Spellchecker::Mistake, nil]
    def call(token)
      text, correction = find_ngram(token)

      return unless correction

      correction = correction.sub(/\S/, &:upcase) if text.match?(/\A[A-Z]/)

      Mistake.new(text: text, correction: correction,
                  position: token.position, type: MistakeTypes::GRAMMAR)
    end

    # @param token [Spellchecker::Tokenizer::Token]
    # @return [Array<(String, String)>, nil]
    def find_ngram(token)
      NGRAM_RANGE.each_with_object([token.normalized]) do |i, list|
        token = token.next

        break if token.text.match?(SEPARATOR_REGEXP)

        list << token.normalized
        correction = Dictionaries::NgramList.match(list)

        break fetch_original_text(token, i), correction if correction
        break if i == NGRAM_RANGE.end
      end
    end

    # @param token [Spellchecker::Tokenizer::Token]
    # @param index [Integer]
    # @return [String]
    def fetch_original_text(token, index)
      _, list =
        (index + 1).times.reduce([token, []]) do |(t, acc), _|
          [t.prev, acc.prepend(t.text)]
        end

      list.join(' ')
    end
  end
end
