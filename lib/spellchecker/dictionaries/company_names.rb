# frozen_string_literal: true

module Spellchecker
  module Dictionaries
    module CompanyNames
      PATH = Dictionaries.path.join('company_names.txt')
      MUTEX = Mutex.new

      module_function

      # @return [Set<String>]
      def all
        @all || MUTEX.synchronize do
          @all ||= Set.new(PATH.read.split("\n"))
        end
      end

      # @param string [String]
      # @return [Boolean]
      def include?(string)
        return false unless string

        all.include?(Utils.remove_suffix(string))
      end
    end
  end
end
