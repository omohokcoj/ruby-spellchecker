# frozen_string_literal: true

require_relative 'tokenizer/token'
require_relative 'tokenizer/list'
require_relative 'tokenizer/null_token'

module Spellchecker
  module Tokenizer
    BLANK_REGEXP = /[[:blank:]]/.freeze
    WORD_REGEXP = /[[:word:]]/.freeze
    LINEBREAK = "\n"

    DOT = '.'

    SIMPLE_PRE = ['¿', '¡'].freeze
    SIMPLE_POST = ['!', '?', ',', ':', ';', '.'].freeze
    PAIR_PRE = ['(', '{', '[', '<', '«', '„', '‘'].freeze
    PAIR_POST = [')', '}', ']', '>', '»', '“', '’'].freeze
    PRE_N_POST = ['"', "'", '`'].freeze

    SPLITTABLES = SIMPLE_PRE + SIMPLE_POST + PAIR_PRE + PAIR_POST + PRE_N_POST

    SPLITTABLES_REGEXP = Regexp.new("[#{Regexp.escape(SPLITTABLES.join)}]")

    module_function

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    # @param str [String] string to be tokenized.
    # @return [Spellchecker::Tokenizer::List]
    def call(str)
      chars = str.chars
      pos = 0
      list = Tokenizer::List.new

      (chars.length + 1).times.each_with_object([]) do |i, acc|
        char = chars[i]

        if char.nil?
          list << Token.new(acc.join, pos) unless acc.empty?

          break
        end

        if char.match?(BLANK_REGEXP)
          list << Token.new(acc.join, pos) unless acc.empty?
          acc.clear
        elsif splitable?(char)
          is_next_wordchar = word_char?(chars[i + 1])

          if acc.empty? && char == DOT && is_next_wordchar
            pos = i
            acc << char
          elsif !word_char?(chars[i - 1]) || !is_next_wordchar
            list << Token.new(acc.join, pos) unless acc.empty?
            list << Token.new(char, i)

            acc.clear
          else
            acc << char
          end
        else
          pos = i if acc.empty?
          acc << char
        end
      end

      list
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity

    # @param char [String]
    # @return [Boolean]
    def splitable?(char)
      SPLITTABLES_REGEXP.match?(char) || char == LINEBREAK
    end

    # @param char [String]
    # @return [Boolean]
    def word_char?(char)
      char&.match?(WORD_REGEXP)
    end
  end
end
