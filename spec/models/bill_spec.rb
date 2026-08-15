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

require 'rails_helper'

RSpec.describe Bill do
  it 'is valid with all attributes' do
    expect(build(:bill)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build(:bill, title: nil)).not_to be_valid
  end

  it 'rejects a bill type outside the API list' do
    expect(build(:bill, type: 'notatype')).not_to be_valid
  end

  it 'stores a bill type without triggering STI' do
    bill = described_class.create!(title: 'Test Act', congress: 119,
                                   number: 1, original_chamber: 'house', type: 'hr')
    expect(bill.reload.type).to eq('hr')
  end
end
