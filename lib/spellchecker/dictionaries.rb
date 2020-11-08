# frozen_string_literal: true

module Spellchecker
  module Dictionaries
    module_function

    # @return [Pathname]
    def path
      Pathname.new(File.expand_path('../../dictionaries', __dir__))
    end
  end
end

require_relative 'dictionaries/us_toponyms'
require_relative 'dictionaries/human_names'
require_relative 'dictionaries/company_names'
require_relative 'dictionaries/english_words'
require_relative 'dictionaries/typos_list'
require_relative 'dictionaries/ngram_list'
