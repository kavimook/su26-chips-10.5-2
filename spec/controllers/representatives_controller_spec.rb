# frozen_string_literal: true

require 'rails_helper'

describe RepresentativesController do
  describe 'GET #show' do
    # Create a dummy representative in the test database
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

    let(:rep) do
      Representative.create!(
        name: 'John Doe',
        ocdid: 'ocd-division/country:us/state:ca',
        title: 'Senator',
        party: 'Independent',
        address: '123 Main St',
        photo_url: 'http://example.com/photo.jpg'
      )
    end

    it 'assigns the requested representative to @representative' do
      get :show, params: { id: rep.id }
      expect(assigns(:representative)).to eq(rep)
    end

    it 'renders the show template' do
      get :show, params: { id: rep.id }
      expect(response).to render_template(:show)
    end

    it 'returns a successful response' do
      get :show, params: { id: rep.id }
      expect(response).to be_successful
    end

    context 'when the representative has only a name and OCD ID' do
      let(:sparse_rep) do
        Representative.create!(
          name: 'Sam Smith',
          ocdid: '999999'
        )
        # title, party, phone, website, address, birthday, gender,
        # twitter, facebook, and photo_url are all left nil on purpose
      end

      it 'renders the show page without raising on missing fields' do
        get :show, params: { id: sparse_rep.id }
        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end
  end
end
