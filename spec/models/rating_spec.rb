# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating do
  let(:representative) do
    Representative.create!(name: 'Jane Doe', ocdid: '412345', title: 'Representative')
  end

  let(:news_item) do
    representative.news_items.create!(title: 'A', link: 'http://e.com', issue: 'Immigration')
  end

  let(:user) { User.create!(uid: 'u1', provider: :github, email: 'a@example.com') }

  it 'is valid with a score in range' do
    expect(described_class.new(news_item: news_item, user: user, score: 3)).to be_valid
  end

  it 'rejects a score above the maximum' do
    expect(described_class.new(news_item: news_item, user: user, score: 6)).not_to be_valid
  end

  it 'rejects a second rating from the same user on the same article' do
    described_class.create!(news_item: news_item, user: user, score: 3)
    expect(described_class.new(news_item: news_item, user: user, score: 5)).not_to be_valid
  end

  it 'refreshes the article average when a rating is saved' do
    described_class.create!(news_item: news_item, user: user, score: 4)
    expect(news_item.reload.average_rating).to eq(4.0)
  end

  it 'recomputes the average across several ratings' do
    other = User.create!(uid: 'u2', provider: :github, email: 'b@example.com')
    described_class.create!(news_item: news_item, user: user, score: 5)
    described_class.create!(news_item: news_item, user: other, score: 2)
    expect(news_item.reload.average_rating).to eq(3.5)
  end

  it 'clears the average when the last rating is destroyed' do
    rating = described_class.create!(news_item: news_item, user: user, score: 4)
    rating.destroy
    expect(news_item.reload.average_rating).to be_nil
  end
end
