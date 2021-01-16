# frozen_string_literal: true

module Spellchecker
  module DetectDuplicate
    MIN_LENGTH = 2

    SKIP_WORDS = Set.new(
      %w[very many truly yeah much far yada yare blah
         bla etc win toco really super peri long
         had have happened good goody ever dub bye
         mommy wild that right well huge large dan tan
         yum yummy agar kori lai please mumble extremely
         highly root whoa knock check woof bounce bouncy
         million tut wow mola paw hubba histrio cha nom
         chop same extra more bang big go no pom la ah
         ha oh ew hey]
    ).freeze

    SKIP_PHRASES = Set.new(['try and', 'and try', 'and again', 'again and',
                            'hand in', 'over and', 'and over', 'more and',
                            'and more', 'test and', 'and test', 'after month',
                            'bigger and', 'and bigger', 'hours and', 'and hours',
                            'month after', 'and deeper', 'deeper and', 'step by',
                            'by step', 'and purred', 'pages of', 'and lots',
                            'and on', 'face to', 'louder and', 'and louder',
                            'and thousands', 'day by', 'years and', 'such and',
                            'and so', 'and such', 'one by', 'side to',
                            'thousands of', 'back to', 'bit by', 'years of',
                            'days of', 'weeks of']).freeze

    SKIP_PHRASE_WORDS = Set.new(%w[and])

    module_function

    # @param token [Spellchecker::Tokenizer::Token]
    # @return [Spellchecker::Mistake, nil]
    def call(token)
      t1 = token

      return if t1.text.length < MIN_LENGTH
      return if SKIP_WORDS.include?(t1.downcased)

      t2 = t1.next
      t3 = t2.next
      t4 = t3.next

      text, correction = find_duplicate(t1, t2, t3, t4)

      return unless text
      return if SKIP_PHRASES.include?(correction.downcase)
      return unless Dictionaries::EnglishWords.include?(t2.text)

      return if skip_phrase?(t1, t2, t3, t4)
      return if repetition?(t1, t2, t3, t4)
      return if from_to_phrase?(t1, t2, t3)
      return if quoted?(t1, t2, t3, t4)

      Mistake.new(text: text, correction: correction,
                  position: token.position, type: MistakeTypes::DUPLICATE)
    end

    # @param t1 [Spellchecker::Tokenizer::Token]
    # @param t2 [Spellchecker::Tokenizer::Token]
    # @param t3 [Spellchecker::Tokenizer::Token]
    # @param t4 [Spellchecker::Tokenizer::Token]
    # @return [Spellchecker::Mistake, nil]
    def find_duplicate(t1, t2, t3, t4)
      if t1.downcased == t2.downcased && !t2.capital? && !t2.digit?
        [[t1, t2].map(&:text).join(' '), t1.text]
      elsif [t1.downcased, t2.downcased] == [t3.downcased, t4.downcased] && !t3.capital? && !t3.digit?
        [[t1, t2, t3, t4].map(&:text).join(' '), [t1, t2].map(&:text).join(' ')]
      end
    end

    def skip_phrase?(t1, t2, t3, t4)
      return true if t1.downcased == t3.downcased && SKIP_PHRASE_WORDS.include?(t1.downcased)
      return true if t2.downcased == t4.downcased && SKIP_PHRASE_WORDS.include?(t2.downcased)

      false
    end

    # rubocop:disable Metrics/AbcSize
    def repetition?(t1, t2, t3, t4)
      return true if t1.downcased == t3.downcased && t1.downcased == t4.next.downcased
      return true if t1.prev.downcased == t2.downcased && t2.downcased == t4.downcased
      return true if t1.prev.downcased == t1.downcased && t1.downcased == t3.downcased
      return true if t1.downcased == t2.downcased && (t1.downcased == t3.downcased ||
                                                      t1.downcased == t1.prev.downcased ||
                                                      t1.downcased == t4.downcased)

      false
    end
    # rubocop:enable Metrics/AbcSize

    def quoted?(t1, _t2, t3, t4)
      t1.prev.text == '"' && (t3.text == '"' || t4.text == '"')
    end

    def from_to_phrase?(t1, t2, t3)
      t1.prev.downcased == 'from' && t2.downcased == 'to' && t1.downcased == t3.downcased
    end
  end
end
