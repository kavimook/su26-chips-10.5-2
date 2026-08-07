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

RSpec.describe Representative, type: :model do
  let(:rep_info) do
    JSON.parse(<<~JSON)
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
    JSON
  end

  it "creates a representative" do
    Representative.civic_api_to_representative_params(rep_info)
    
    expect(Representative, :count).to eq(1) # Assert
  end

  it "rejects duplicate representative" do
    Representative.civic_api_to_representative_params(rep_info)
    
    expect {Representative.civic_api_to_representative_params(rep_info)}.to raise_error("Representative Already Exists")
  end

end

# This file is a stub.
# You should add your own test cases.
# We recommend creating a file for each model in the database.

# RSpec.describe Representative do
# end
