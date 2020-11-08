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
        "#<#{self.class} ('#{text}', #{position})>"
      end

      # @return [String]
      def normalized
        @normalized ||= Utils.replace_quote(downcased)
      end

      # @return [Boolean]
      def capital?
        @capital ||= text.match?(/\A[A-Z]/)
      end

      # @return [String]
      def downcased
        @downcased ||= text.downcase
      end
    end
  end
end
