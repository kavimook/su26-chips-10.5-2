# frozen_string_literal: true

# == Schema Information
#
# Table name: bills
#
#  id               :integer          not null, primary key
#  congress         :integer
#  number           :integer
#  original_chamber :string
#  summary          :text
#  title            :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Bill < ApplicationRecord
  # `type` is Rails' Single Table Inheritance column by default, which would make
  # ActiveRecord try to instantiate a class named e.g. "hr". We store a bill type
  # code there instead, so STI must be turned off.
  self.inheritance_column = nil

  # Valid bill types from the congress.gov API.
  TYPES = %w[hr s hjres sjres hconres sconres hres sres].freeze

  CHAMBERS = %w[house senate].freeze

  validates :title, presence: true
  validates :type, inclusion: { in: TYPES }, allow_blank: true
  validates :original_chamber, inclusion: { in: CHAMBERS }, allow_blank: true
end
