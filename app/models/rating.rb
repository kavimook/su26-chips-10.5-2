# frozen_string_literal: true

class Rating < ApplicationRecord
  MIN_SCORE = 1
  MAX_SCORE = 5

  belongs_to :news_item
  belongs_to :user

  validates :score, inclusion: { in: MIN_SCORE..MAX_SCORE }
  validates :user_id, uniqueness: { scope: :news_item_id }

  after_destroy :refresh_news_item_average
  after_save :refresh_news_item_average

  private

  def refresh_news_item_average
    news_item.refresh_average_rating!
  end
end
