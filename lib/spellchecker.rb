# frozen_string_literal: true

require 'csv'
require 'pathname'
require 'set'

require_relative 'spellchecker/version'
require_relative 'spellchecker/utils'
require_relative 'spellchecker/dictionaries'
require_relative 'spellchecker/tokenizer'
require_relative 'spellchecker/detect_duplicate'
require_relative 'spellchecker/detect_typo'
require_relative 'spellchecker/detect_ngram'

module Spellchecker
  module MistakeTypes
    ALL = [
      DUPLICATE = 'duplicate',
      SPELLING = 'spelling',
      GRAMMAR = 'grammar'
    ].freeze
  end

  Mistake = Struct.new(:text,
                       :correction,
                       :context,
                       :type,
                       :position, keyword_init: true)

  module_function

  # @param text [String]
  # @return [Array<Spellchecker::Mistake>]
  def check(text)
    tokens = Tokenizer.call(text)

    mistakes =
      tokens.each_with_object([]) do |token, acc|
        DetectDuplicate.call(token)&.then { |m| acc << m }
        DetectTypo.call(token)&.then { |m| acc << m }
        DetectNgram.call(token)&.then { |m| acc << m }
      end

    mistakes.each { |mistake| mistake.context = Utils.fetch_context(text, mistake.position) }

    mistakes
  end

  # @param text [String]
  # @return [String]
  def correct(text)
    mistakes = check(text)

    apply_fixes(text, mistakes)
  end

  # @param text [String]
  # @param mistakes [Array<Spellchecker::Mistake>]
  # @return [String]
  def apply_fixes(text, mistakes)
    mistakes_hash = mistakes.map { |m| [m.text, m.correction] }.to_h
    regexp = Regexp.union(mistakes_hash.keys)

    text.gsub(regexp, mistakes_hash)
  end
end
