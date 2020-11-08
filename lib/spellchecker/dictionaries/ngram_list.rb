# frozen_string_literal: true

module Spellchecker
  module Dictionaries
    module NgramList
      MUTEX = Mutex.new
      PATH = Dictionaries.path.join('ngrams.csv')

      module_function

      # @return [Hash<Array<String>, String>]
      def all
        @all || MUTEX.synchronize do
          @all ||= CSV.parse(PATH.read).to_h.transform_keys { |e| e.split(' ') }
        end
      end

      # @param list [Array<String>]
      # @return [Boolean]
      def include?(list)
        !match(list).nil?
      end

      # @param list [Array<String>]
      # @return [String]
      def match(list)
        all[list]
      end
    end
  end
end
