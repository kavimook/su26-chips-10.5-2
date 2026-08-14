# frozen_string_literal: true

# == Schema Information
#
# Table name: news_items
#
#  id                :integer          not null, primary key
#  description       :text
#  issue             :string
#  link              :string           not null
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  representative_id :integer          not null
#
# Indexes
#
#  index_news_items_on_representative_id  (representative_id)
#
require 'rails_helper'

RSpec.describe NewsItem do
  let(:representative) do
    Representative.create!(name: 'Jane Doe', ocdid: '12345', title: 'Senator')
  end

  describe '.issues' do
    it 'returns all seventeen issues' do
      expect(described_class.issues.length).to eq(17)
    end

    it 'includes a multi-word issue' do
      expect(described_class.issues).to include('Social Security and Medicare')
    end

    it 'returns a frozen list' do
      expect(described_class.issues).to be_frozen
    end
  end

  describe 'issue validation' do
    it 'accepts an issue from the list' do
      item = described_class.new(title: 'A', link: 'http://e.com',
                                 representative: representative, issue: 'Immigration')
      expect(item).to be_valid
    end

    it 'rejects an issue not on the list' do
      item = described_class.new(title: 'A', link: 'http://e.com',
                                 representative: representative, issue: 'Bananas')
      expect(item).not_to be_valid
    end

    it 'allows a blank issue' do
      item = described_class.new(title: 'A', link: 'http://e.com',
                                 representative: representative, issue: '')
      expect(item).to be_valid
    end
  end
end
