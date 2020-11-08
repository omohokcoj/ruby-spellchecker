# frozen_string_literal: true

module Spellchecker
  module Tokenizer
    class List
      include Enumerable

      attr_reader :last

      def initialize
        @list = []
        @last = Tokenizer::NULL_TOKEN
      end

      # @param token [Spellchecker::Tokenizer::Token]
      # return [Spellchecker::Tokenizer::Token]
      def add(token)
        @last.next = token
        token.prev = @last

        @list << token
        @last = token

        token
      end
      alias << add

      def each(&block)
        @list.each(&block)
      end

      # @param index [Integer]
      # @return [Spellchecker::Tokenizer::Token]
      def [](index)
        @list[index]
      end
    end
  end
end
