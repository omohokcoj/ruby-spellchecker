# frozen_string_literal: true

RSpec.describe Spellchecker::DetectNgram do
  subject(:token) { Spellchecker::Tokenizer.call(text).first }

  context '#call' do
    context do
      let(:text) { 'within it`s' }

      it 'return `within its` correction' do
        expect(described_class.call(token).correction).to eq 'within its'
      end
    end
  end
end
