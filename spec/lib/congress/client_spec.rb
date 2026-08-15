# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Congress::Client do
  subject(:client) { described_class.new('test-key') }

  let(:payload) do
    { 'bills' => [{ 'title' => 'A Bill' }], 'pagination' => { 'count' => 1 } }
  end

  before do
    stub_request(:get, /api\.congress\.gov/).to_return(
      status:  200,
      body:    payload.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  it 'errors without an api key' do
    expect { described_class.new(nil) }.to raise_error(ArgumentError)
  end

  it 'errors on a blank api key' do
    expect { described_class.new('   ') }.to raise_error(ArgumentError)
  end

  describe '#bills' do
    it 'requests the most recent bills when given no filters' do
      client.bills(limit: 50).get
      expect(a_request(:get, 'https://api.congress.gov/v3/bill')
        .with(query: hash_including('limit' => '50'))).to have_been_made
    end

    it 'scopes the path to a congress session' do
      client.bills(congress: 119).get
      expect(a_request(:get, 'https://api.congress.gov/v3/bill/119')
        .with(query: hash_including)).to have_been_made
    end

    it 'scopes the path to a congress session and bill type' do
      client.bills(congress: 119, type: 'hr').get
      expect(a_request(:get, 'https://api.congress.gov/v3/bill/119/hr')
        .with(query: hash_including)).to have_been_made
    end

    it 'returns the parsed response body' do
      expect(client.bills(congress: 119).get).to eq(payload)
    end
  end

  describe 'error handling' do
    it 'raises on an unauthorized response' do
      stub_request(:get, /api\.congress\.gov/).to_return(status: 401)
      expect { client.bills(congress: 119).get }.to raise_error(Congress::Error, /Unauthorized/)
    end

    it 'raises when the resource is missing' do
      stub_request(:get, /api\.congress\.gov/).to_return(status: 404)
      expect { client.bills(congress: 119).get }.to raise_error(Congress::Error, /Not found/)
    end

    it 'raises when rate limited' do
      stub_request(:get, /api\.congress\.gov/).to_return(status: 429)
      expect { client.bills(congress: 119).get }.to raise_error(Congress::Error, /Rate limit/)
    end
  end
end
