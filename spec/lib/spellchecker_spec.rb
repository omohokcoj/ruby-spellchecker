# frozen_string_literal: true

RSpec.describe Spellchecker do
  context '#check' do
    it 'returns grammar error' do
      expect(described_class.check("And it's origin")).to eq(
        [Spellchecker::Mistake.new(text: "it's origin",
                                   correction: 'its origin',
                                   context: "And it's origin",
                                   type: 'grammar',
                                   position: 4)]
      )
    end

    it 'returns spelling error' do
      expect(described_class.check('gret sucess')).to eq(
        [Spellchecker::Mistake.new(text: 'gret',
                                   correction: 'great',
                                   context: 'gret sucess',
                                   type: 'spelling',
                                   position: 0),
         Spellchecker::Mistake.new(text: 'sucess',
                                   correction: 'success',
                                   context: 'gret sucess',
                                   type: 'spelling',
                                   position: 5)]
      )
    end

    it 'returns duplicate error' do
      expect(described_class.check('The purpose purpose of this...')).to eq(
        [Spellchecker::Mistake.new(text: 'purpose purpose',
                                   correction: 'purpose',
                                   context: 'The purpose purpose of this...',
                                   type: 'duplicate',
                                   position: 4)]
      )
    end
  end

  context '#correct' do
    let(:text) do
      <<~TEXT
        I started my schooling as the majority did in my area, at the local primarry school. I then went to the local secondarry school and recieved grades in English, Maths, Phisics, Biology, Geography, Art, Graphical Comunication and Philosophy of Religeon. I'll not bore you with the 'A' levels and above.
        Notice the ambigous English qualification above. It was, in truth, a cource dedicated to reading "Lord of the flies" and other gems, and a weak atempt at getting us to commprehend them. Luckilly my middle-class upbringing gave me a head start as I was already aquainted with that sort of langauge these books used (and not just the Peter and Jane books) and had read simillar books before. I will never be able to put that paticular course down as much as I desire to because, for all its faults, it introduced me to Steinbeck, Malkovich and the wonders of Lenny, mice and pockets.
        My education never included one iota of grammar. Lynn Truss points out in "Eats, shoots and leaves" that many people were excused from the rigours of learning English grammar during their schooling over the last 30 or so years because the majority or decision-makers decided one day that it might hinder imagination and expresion (so what, I ask, happened to all those expresive and imaginative people before the ruling?).
      TEXT
    end

    it 'returns fixed text' do
      expect(described_class.correct(text)).to eq(
        <<~TEXT
          I started my schooling as the majority did in my area, at the local primary school. I then went to the local secondary school and received grades in English, Maths, Physics, Biology, Geography, Art, Graphical Communication and Philosophy of Religion. I'll not bore you with the 'A' levels and above.
          Notice the ambiguous English qualification above. It was, in truth, a course dedicated to reading "Lord of the flies" and other gems, and a weak attempt at getting us to comprehend them. Luckily my middle-class upbringing gave me a head start as I was already acquainted with that sort of language these books used (and not just the Peter and Jane books) and had read similar books before. I will never be able to put that particular course down as much as I desire to because, for all its faults, it introduced me to Steinbeck, Malkovich and the wonders of Lenny, mice and pockets.
          My education never included one iota of grammar. Lynn Truss points out in "Eats, shoots and leaves" that many people were excused from the rigours of learning English grammar during their schooling over the last 30 or so years because the majority or decision-makers decided one day that it might hinder imagination and expression (so what, I ask, happened to all those expressive and imaginative people before the ruling?).
        TEXT
      )
    end
  end
end
