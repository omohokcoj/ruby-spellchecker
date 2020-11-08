# frozen_string_literal: true

RSpec.describe Spellchecker::Tokenizer do
  context '#call' do
    it 'returns valid tokens' do
      text = <<~TEXT.strip
        Mail Attachment Support Viewable document types (apple.com)
        .jpg, .tiff, .gif (images); .doc and .docx (Microsoft Word); .htm and .html (web pages); .key (Keynote); .numbers (Numbers); .pages (Pages); .pdf (Preview and Adobe Acrobat); .ppt and .pptx (Microsoft PowerPoint); .txt (text); .rtf (rich text format); .vcf (contact information); .xls and .xlsx (Microsoft Excel); .zip; .ics; .usdz (USDZ-Universal).
      TEXT

      expect(described_class.call(text).map(&:text)).to eq(
        ['Mail', 'Attachment', 'Support', 'Viewable', 'document', 'types', '(', 'apple.com', ')',
         "\n", '.jpg', ',', '.tiff', ',', '.gif', '(', 'images', ')', ';', '.doc', 'and', '.docx',
         '(', 'Microsoft', 'Word', ')', ';', '.htm', 'and', '.html', '(', 'web', 'pages', ')', ';',
         '.key', '(', 'Keynote', ')', ';', '.numbers', '(', 'Numbers', ')', ';', '.pages', '(', 'Pages',
         ')', ';', '.pdf', '(', 'Preview', 'and', 'Adobe', 'Acrobat', ')', ';', '.ppt', 'and', '.pptx',
         '(', 'Microsoft', 'PowerPoint', ')', ';', '.txt', '(', 'text', ')', ';', '.rtf', '(', 'rich',
         'text', 'format', ')', ';', '.vcf', '(', 'contact', 'information', ')', ';', '.xls', 'and',
         '.xlsx', '(', 'Microsoft', 'Excel', ')', ';', '.zip', ';', '.ics', ';', '.usdz', '(',
         'USDZ-Universal', ')', '.']
      )
    end
  end
end
