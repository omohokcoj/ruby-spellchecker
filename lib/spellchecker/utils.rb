# frozen_string_literal: true

module Spellchecker
  module Utils
    CONTEXT_LENGTH = 140
    CONTEXT_PART_LENGTH = CONTEXT_LENGTH / 2

    QUOTE_REPLACE = '’`'
    SUFFIX_REGEXP = /[’`']s?\z/.freeze

    module_function

    # @param text [String]
    # @param position [Integer]
    # @return [String]
    def fetch_context(text, position)
      start_from = [position - CONTEXT_PART_LENGTH, 0].max
      end_at = position + CONTEXT_PART_LENGTH

      context = text[start_from..end_at].strip
      context = context.sub(/\A\w*?\W+/, '') if start_from != 0
      context = context.sub(/\W+\w*?\z/, '') if end_at < text.length

      context.strip
    end

    # @param string [String]
    # @return [String]
    def replace_quote(string)
      string.tr(QUOTE_REPLACE, "'")
    end

    # @param string [String]
    # @return [String]
    def remove_suffix(string)
      string.sub(SUFFIX_REGEXP, '')
    end
  end
end
