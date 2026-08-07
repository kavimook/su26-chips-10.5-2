# frozen_string_literal: true

# == Schema Information
#
# Table name: representatives
#
#  id         :integer          not null, primary key
#  city       :string
#  name       :string
#  ocdid      :string
#  party      :string
#  photo_url  :string
#  state      :string
#  street     :string
#  title      :string
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

# This file is a stub.
# You should add your own test cases.
# We recommend creating a file for each model in the database.

# RSpec.describe Representative do
# end


describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    let(:rep_info) do
      {       
        "results": [{
          "response": {
            "results": [{
              "fields": {
                "congressional_districts": [{
                  "name": "Congressional District 12",
                  "district_number": 12,
                  "ocd_id": "ocd-division/country:us/state:ca/cd:12",
                  "current_legislators": [{
                    "type": "representative",
                    "bio": {
                      "first_name": "Jane",
                      "last_name": "Doe",
                      "party": "Democrat",
                      "gender": "F"
                    },
                    "contact": {
                      "url": "https://doe.house.gov",
                      "address": "1234 Longworth House Office Building; Washington DC 20515",
                      "phone": "202-225-0000"
                    },
                    "social": { "twitter": "repjanedoe" },
                    "references": {
                      "bioguide_id": "D000000",
                      "govtrack_id": "412345"
                    }
                  }]
                }]
              }
            }]
          }
        }]
      }
    end

    it 'creates a new representative when one does not exist' do
      expect {
        Representative.civic_api_to_representative_params(rep_info)
      }.to change(Representative, :count).by(1)
    end

    it 'does not create a duplicate representative if they already exist in the database' do
      Representative.create!(
        name: 'Jane Doe', 
        ocdid: '412345', 
        title: 'Representative'
      )

      expect {
        Representative.civic_api_to_representative_params(rep_info)
      }.not_to change(Representative, :count)
      
      # 3. Ensure the method still returns the existing representative in its output
      reps = Representative.civic_api_to_representative_params(rep_info)
      expect(reps.length).to eq(1)
      expect(reps.first.name).to eq('Jane Doe')
    end
  end
end

    