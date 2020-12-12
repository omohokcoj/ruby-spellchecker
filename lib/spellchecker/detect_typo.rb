# frozen_string_literal: true

module Spellchecker
  module DetectTypo
    PROPER_NAME_REGEXP = /\A(?:[a-z]+[A-Z])|(?:[A-Z]+.+[A-Z]+)|(?:[A-Z]{2,}[^A-Z]+)/.freeze
    ABBREVIATION_REGEXP = /\A(?:[A-Z]{2,4})|(?:[A-Z][a-z])\z/.freeze

    LENGTH_LIMIT = 2
    ABBREVIATION_LENGTH = 2
    NUMBER_SHORTENING_SUFFIX = 'th'
    SHORTENINGS = Set.new(%w[ver]).freeze

    module_function

    # @param token [Spellchecker::Tokenizer::Token]
    # @return [Spellchecker::Mistake, nil]
    def call(token)
      word = token.text

      return if word.length < LENGTH_LIMIT

      correction = Dictionaries::TyposList.match_token(token)

      return unless correction
      return if PROPER_NAME_REGEXP.match?(word)
      return if abbreviation?(token) || shortening?(token)
      return if Dictionaries::EnglishWords.include?(Utils.replace_quote(word))

      return if token.capital? && proper_noun?(word)

      correction = correction.sub(/\S/, &:upcase) if token.capital?

      Mistake.new(text: word, correction: correction,
                  position: token.position, type: MistakeTypes::SPELLING)
    end

    # @param word [String]
    # @return [Boolean]
    def proper_noun?(word)
      Dictionaries::HumanNames.include?(word) ||
        Dictionaries::CompanyNames.include?(word) ||
        Dictionaries::UsToponyms.include?(word)
    end

    # @param token [Spellchecker::Tokenizer::Token]
    # @return [Boolean]
    def abbreviation?(token)
      return true if ABBREVIATION_REGEXP.match?(token.text)
      return true if token.text.length <= ABBREVIATION_LENGTH &&
                     !token.prev.word? && !token.next.word?

      false
    end

    # @param token [Spellchecker::Tokenizer::Token]
    # @return [Boolean]
    def shortening?(token)
      return true if token.text == NUMBER_SHORTENING_SUFFIX && token.prev.digit?
      return true if SHORTENINGS.include?(token.downcased) &&
                     (token.next.dot? || token.next.digit?)

      false
    end
  end
end
