# frozen_string_literal: true

module Spellchecker
  module Dictionaries
    module TyposList
      MUTEX = Mutex.new
      PATH = Dictionaries.path.join('typos.csv')

      module_function

      # @return [Hash<String, String>]
      def all
        @all || MUTEX.synchronize do
          @all ||= CSV.parse(PATH.read).to_h
        end
      end

      # @param word [String]
      # @return [Boolean]
      def include?(word)
        !match(word).nil?
      end

      # @param word [String]
      # @return [String, nil]
      def match(word)
        all[Utils.replace_quote(word.to_s.downcase)]
      end

      # @param token [Spellchecker::Tokenizer::Token]
      # @return [String, nil]
      def match_token(token)
        all[token.normalized]
      end
    end
  end
end
