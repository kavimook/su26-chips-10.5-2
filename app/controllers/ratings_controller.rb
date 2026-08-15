# frozen_string_literal: true

class RatingsController < ApplicationController
  before_action :require_login!
  before_action :set_news_item

  def create
    rating = @news_item.ratings.find_or_initialize_by(user: current_user)
    rating.score = params[:score]
    path = representative_news_item_path(params[:representative_id], @news_item)

    if rating.save
      redirect_to path, notice: 'Thanks for rating this article.'
    else
      redirect_to path, alert: rating.errors.full_messages.to_sentence
    end
  end

  private

  def set_news_item
    @news_item = NewsItem.find(params[:news_item_id])
  end
end
