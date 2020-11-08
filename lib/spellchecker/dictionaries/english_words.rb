# frozen_string_literal: true

module Spellchecker
  module Dictionaries
    module EnglishWords
      # http://wordlist.aspell.net/dicts/
      PATH = Dictionaries.path.join('english_words.txt')
      MUTEX = Mutex.new

      module_function

      # @return [Set<String>]
      def all
        @all || MUTEX.synchronize do
          @all ||= Set.new(PATH.read.split("\n"))
        end
      end

      # @param word [String]
      # @return [Boolean]
      def include?(word)
        return false unless word

        all.include?(word.downcase)
      end
    end
  end
end
