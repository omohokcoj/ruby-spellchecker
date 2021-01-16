# frozen_string_literal: true

RSpec.describe Spellchecker::DetectDuplicate do
  subject(:tokens) { Spellchecker::Tokenizer.call(text) }
  subject(:token) { tokens.first }

  context '#call' do
    context do
      let(:text) { 'Again and again and again' }

      it 'does not return `and again`' do
        expect(described_class.call(token)).to be_nil
      end
    end

    context do
      let(:text) { 'very very good' }

      it 'does not return `very very`' do
        expect(described_class.call(token)).to be_nil
      end
    end

    context do
      let(:text) { 'tree tree tree repetiton' }

      it 'does not return 3 in a row repetition' do
        expect(described_class.call(token)).to be_nil
      end
    end

    context do
      let(:text) { 'discuss discuss and discuss' }

      it 'does not return 2 and 1 repetition' do
        expect(described_class.call(token)).to be_nil
      end
    end

    context do
      let(:text) { 'ghr ghr' }

      it 'does not return non-EN words' do
        expect(described_class.call(token)).to be_nil
      end
    end

    context do
      let(:text) { 'from book to book to see' }

      it 'does not return `from ... to ... to` duplicate' do
        expect(described_class.call(tokens[1])).to be_nil
      end
    end

    context do
      let(:text) { 'Game of Game of Thrones' }

      it 'does not capitalized words duplicate' do
        expect(described_class.call(token)).to be_nil
      end
    end

    context do
      let(:text) { '12 x 12 x' }

      it 'does not digits duplicate' do
        expect(described_class.call(token)).to be_nil
      end
    end
  end
end
