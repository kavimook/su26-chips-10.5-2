# frozen_string_literal: true

# == Schema Information
#
# Table name: representatives
#
#  id         :integer          not null, primary key
#  address    :string
#  birthday   :string
#  facebook   :string
#  gender     :string
#  name       :string
#  ocdid      :string
#  party      :string
#  phone      :string
#  photo_url  :string
#  title      :string
#  twitter    :string
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

# This file is a stub.
# You should add your own test cases.
# We recommend creating a file for each model in the database.

# RSpec.describe Representative do
# end

describe Representative do
  before do
    fake_geocodio_response = {
      'results' => [{
        'response' => {
          'results' => [{
            'fields' => {
              'congressional_districts' => [{
                'current_legislators' => [{
                  'type' => 'representative',
                  'bio' => { 'first_name' => 'John', 'last_name' => 'Doe', 'party' => 'Democrat' },
                  'contact' => { 'address' => '123 Main St', 'phone' => '555-1234' },
                  'references' => { 'bioguide_id' => 'D000123', 'govtrack_id' => '412345' }
                }]
              }]
            }
          }]
        }
      }]
    }.to_json

    # Notice it says :post here now!
    stub_request(:post, /api\.geocod\.io/)
      .to_return(
        status: 200,
        body: fake_geocodio_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe '.civic_api_to_representative_params' do
    let(:rep_info) do
      {
        'results' => [{
          'response' => {
            'results' => [{
              'fields' => {
                'congressional_districts' => [{
                  'name' => 'Congressional District 12',
                  'current_legislators' => [{
                    'type' => 'representative',
                    'bio' => { 'first_name' => 'Jane', 'last_name' => 'Doe', 'party' => 'Democrat' },
                    'contact' => { 'address' => '123 Main St', 'phone' => '555-1234' },
                    'references' => { 'bioguide_id' => 'D000123', 'govtrack_id' => '412345' }
                  }]
                }]
              }
            }]
          }
        }]
      }
    end

    it 'creates a new representative when one does not exist' do
      expect do
        described_class.civic_api_to_representative_params(rep_info)
      end.to change(described_class, :count).by(1)
    end

    it 'does not create a duplicate representative if they already exist in the database' do
      described_class.create!(
        name: 'Jane Doe',
        ocdid: '412345',
        title: 'Representative'
      )

      expect do
        described_class.civic_api_to_representative_params(rep_info)
      end.not_to change(described_class, :count)

      # 3. Ensure the method still returns the existing representative in its output
      reps = described_class.civic_api_to_representative_params(rep_info)
      expect(reps.length).to eq(1)
      expect(reps.first.name).to eq('Jane Doe')
    end

    context 'when the legislator is missing optional fields' do
      let(:sparse_rep_info) do
        {
          'results' => [{
            'response' => {
              'results' => [{
                'fields' => {
                  'congressional_districts' => [{
                    'name' => 'Congressional District 99',
                    'current_legislators' => [{
                      'type' => 'representative',
                      # No party, birthday, or gender in bio
                      'bio' => { 'first_name' => 'Sam', 'last_name' => 'Smith' },
                      # No phone, url, or address in contact
                      'contact' => {},
                      # No social block at all, no bioguide_id
                      'references' => { 'govtrack_id' => '999999' }
                    }]
                  }]
                }
              }]
            }
          }]
        }
      end

      it 'does not raise and leaves missing fields nil' do
        expect do
          described_class.civic_api_to_representative_params(sparse_rep_info)
        end.not_to raise_error

        rep = described_class.find_by(ocdid: '999999')
        expect(rep.name).to eq('Sam Smith')
        expect(rep.party).to be_nil
        expect(rep.address).to be_nil
        expect(rep.phone).to be_nil
        expect(rep.website).to be_nil
        expect(rep.twitter).to be_nil
        expect(rep.facebook).to be_nil
        expect(rep.birthday).to be_nil
        expect(rep.gender).to be_nil
        expect(rep.photo_url).to be_nil
      end
    end
  end
end
