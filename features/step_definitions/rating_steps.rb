# frozen_string_literal: true

When('I visit the news article page for that representative') do
  news_item = @representative.news_items.first
  visit representative_news_item_path(@representative, news_item)
end
