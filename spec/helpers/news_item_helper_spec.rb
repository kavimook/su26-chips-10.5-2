# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItemHelper do
  let(:representative) do
    Representative.create!(name: 'Jane Doe', ocdid: '412345', title: 'Representative')
  end

  let(:news_item) do
    representative.news_items.create!(title: 'A', link: 'http://e.com', issue: 'Immigration')
  end

  let(:user) { User.create!(uid: 'u1', provider: :github, email: 'a@example.com') }

  describe '#average_rating_label' do
    it 'reports when an article has no ratings' do
      expect(helper.average_rating_label(news_item)).to eq('Not yet rated')
    end

    it 'formats the average and pluralises the count' do
      Rating.create!(news_item: news_item, user: user, score: 4)
      expect(helper.average_rating_label(news_item.reload)).to eq('4.0 / 5 (1 rating)')
    end
  end

  describe '#user_score' do
    it 'returns nil for an anonymous visitor' do
      expect(helper.user_score(news_item, nil)).to be_nil
    end

    it "returns this user's own score" do
      Rating.create!(news_item: news_item, user: user, score: 2)
      expect(helper.user_score(news_item, user)).to eq(2)
    end
  end
end
