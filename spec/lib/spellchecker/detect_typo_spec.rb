# frozen_string_literal: true

RSpec.describe Spellchecker::DetectTypo do
  def token(text)
    Spellchecker::Tokenizer::Token.new(text)
  end

  context '#call' do
    it 'does not return city name' do
      expect(described_class.call(token('Chariton'))).to be_nil
      expect(described_class.call(token('chariton'))).not_to be_nil
    end

    it 'does not return first name' do
      expect(described_class.call(token('Vey'))).to be_nil
      expect(described_class.call(token('vey'))).not_to be_nil
    end

    it 'does not return company name' do
      expect(described_class.call(token('Wizrd'))).to be_nil
      expect(described_class.call(token('wizrd'))).not_to be_nil
    end

    it 'does not return company inflated name' do
      expect(described_class.call(token('Wizrd’s'))).to be_nil
    end

    it 'does not return abbreviation' do
      tokens = Spellchecker::Tokenizer.call('Romanian (ro) domain')

      expect(tokens[2].text).to eq 'ro'
      expect(described_class.call(tokens[2])).to be_nil
    end

    it 'does not return -th shortening' do
      tokens = Spellchecker::Tokenizer.call('20 th domain')

      expect(tokens[1].text).to eq 'th'
      expect(described_class.call(tokens[1])).to be_nil
    end

    it 'does not return shortening with dot' do
      tokens = Spellchecker::Tokenizer.call('ver. 1.1')

      expect(described_class.call(tokens.first)).to be_nil
    end
  end
end
