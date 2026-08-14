# frozen_string_literal: true

Given('a representative with news articles exists') do
  @representative = Representative.create!(
    name: 'Jane Doe',
    ocdid: '412345',
    title: 'Representative',
    party: 'Democrat',
    address: '1234 Longworth House Office Building; Washington DC 20515'
  )
  @representative.news_items.create!(
    title: 'Clean Energy Bill Advances Out of Committee',
    link: 'https://example.com/clean-energy',
    description: 'The measure moved forward with bipartisan support.',
    issue: 'Climate Change'
  )
end

Given('I am logged in') do
  visit '/auth/github/callback'
end

When('I visit the news articles page for that representative') do
  visit representative_news_items_path(@representative)
end

When('I visit the new news article page for that representative') do
  visit representative_new_my_news_item_path(@representative)
end
