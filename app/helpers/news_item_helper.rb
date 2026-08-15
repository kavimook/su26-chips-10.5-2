# frozen_string_literal: true

module NewsItemHelper
  # 'Not yet rated' or '4.3 / 5 (7 ratings)'
  def average_rating_label(news_item)
    return 'Not yet rated' if news_item.average_rating.blank?

    count = news_item.ratings.size
    "#{format('%.1f', news_item.average_rating)} / 5 (#{pluralize(count, 'rating')})"
  end

  # The score this user already gave this article, or nil.
  def user_score(news_item, user)
    news_item.rating_by(user)&.score
  end
end
