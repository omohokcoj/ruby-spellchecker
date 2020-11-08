# frozen_string_literal: true

module Spellchecker
  module Dictionaries
    module UsToponyms
      MUTEX = Mutex.new
      # https://github.com/grammakov/USA-cities-and-states
      PATH = Dictionaries.path.join('us_toponyms.csv')

      module_function

      # @return [Set<String>]
      def all
        @all || MUTEX.synchronize do
          @all ||= load_names
        end
      end

      # @param name [String]
      # @return [Boolean]
      def include?(name)
        return false unless name

        all.include?(Utils.remove_suffix(name))
      end

      # @return [Set<String>]
      def load_names
        csv = CSV.parse(PATH.read, headers: true, col_sep: '|')

        csv.each_with_object(Set.new) do |row, set|
          set.add(row['City']) if row['City']
          set.add(row['State full']) if row['State full']
          set.add(row['County'].to_s.split(/\s+/).map(&:capitalize).join(' ')) unless row['County'].to_s.empty?
          set.add(row['City alias']) if row['City alias']
        end
      end
    end
  end
end
