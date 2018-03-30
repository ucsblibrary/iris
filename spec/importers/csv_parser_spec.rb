# frozen_string_literal: true
require 'rails_helper'

RSpec.describe IrisCsvParser do
  subject(:parser) { described_class.new(file: file) }
  let(:file)       { File.open(csv_path) }
  let(:csv_path) { 'spec/fixtures/empty_row_example.csv' }

  describe '#records' do
    it 'skips records with no values' do
      expect(parser.records.count).to eq 0
    end
  end
end
