# frozen_string_literal: true

# == Schema Information
#
# Table name: news_items
#
#  id                :integer          not null, primary key
#  average_rating    :float
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
class NewsItem < ApplicationRecord
  # TODO: this belongs to a user (creator_id)
  belongs_to :representative
  has_many :ratings, dependent: :destroy

  ISSUES = [
    'Free Speech',
    'Immigration',
    'Terrorism',
    'Social Security and Medicare',
    'Abortion',
    'Student Loans',
    'Gun Control',
    'Unemployment',
    'Climate Change',
    'Homelessness',
    'Racism',
    'Tax Reform',
    'Net Neutrality',
    'Religious Freedom',
    'Border Security',
    'Minimum Wage',
    'Equal Pay'
  ].freeze

  validates :issue, inclusion: { in: ISSUES }, allow_blank: true

  def self.issues
    ISSUES
  end

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def refresh_average_rating!
    update_column(:average_rating, ratings.average(:score)&.to_f) # rubocop:disable Rails/SkipsModelValidations
  end

  def rating_by(user)
    return nil if user.nil?

    ratings.find_by(user_id: user.id)
  end
end
