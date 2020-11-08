# frozen_string_literal: true

module Spellchecker
  module Dictionaries
    module HumanNames
      # https://github.com/philipperemy/name-dataset
      module FirstNames
        MUTEX = Mutex.new
        PATH = Dictionaries.path.join('first_names.txt')

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

          string = Utils.remove_suffix(string.downcase)

          all.include?(string)
        end
      end

      module LastNames
        MUTEX = Mutex.new
        PATH = Dictionaries.path.join('last_names.txt')

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

          string = Utils.remove_suffix(string.downcase)

          all.include?(string)
        end
      end

      module_function

      # @param string [String]
      # @return [Boolean]
      def include?(string)
        return false unless string

        FirstNames.all.include?(string) || LastNames.all.include?(string)
      end
    end
  end
end
