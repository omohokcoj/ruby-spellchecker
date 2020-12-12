# frozen_string_literal: true

module Spellchecker
  module Tokenizer
    class Token
      attr_accessor :text, :position
      attr_writer :next, :prev

      # @param text [String]
      # @param position [Integer]
      def initialize(text, position = 0)
        @text = text
        @position = position
      end

      # @return [Spellchecker::Tokenizer::Token]
      def next
        @next || Tokenizer::NULL_TOKEN
      end

      # @return [Spellchecker::Tokenizer::Token]
      def prev
        @prev || Tokenizer::NULL_TOKEN
      end

      # @return [Boolean]
      def empty?
        self == Tokenizer::NULL_TOKEN
      end

      # @return [String]
      def inspect
        "#<#{self.class} (#{text.inspect}, #{position})>"
      end

      # @return [String]
      def normalized
        @normalized ||= Utils.replace_quote(downcased)
      end

      # @return [Boolean]
      def capital?
        @capital ||= text.match?(/\A[A-Z]/)
      end

      # @return [Boolean]
      def word?
        @word ||= text.length > 1 || text.match?(/\w/)
      end

      # @return [Boolean]
      def digit?
        @digit ||= text.match?(/\A\d+\z/)
      end

      # @return [Boolean]
      def dot?
        @dot ||= text == Tokenizer::DOT
      end

      # @return [String]
      def downcased
        @downcased ||= text.downcase
      end
    end
  end
end
