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

FactoryBot.define do
  factory :bill do
    title { 'A Bill To Improve Something' }
    congress { 119 }
    number { 1234 }
    original_chamber { 'house' }
    type { 'hr' }
    summary { 'A short summary of what this bill does.' }
  end
end
