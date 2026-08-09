# frozen_string_literal: true

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

# Stubs every outbound Geocodio call so no Cucumber scenario ever hits the
# live API (no key in CI, and a third-party outage shouldn't fail our suite).
Before do
  fake_geocodio_response = {
    'results' => [{
      'response' => {
        'results' => [{
          'fields' => {
            'congressional_districts' => [{
              'name' => 'Congressional District 12',
              'current_legislators' => [{
                'type' => 'representative',
                'bio' => { 'first_name' => 'Jane', 'last_name' => 'Doe', 'party' => 'Democrat' },
                'contact' => {
                  'address' => '123 Main St',
                  'phone' => '555-1234',
                  'url' => 'https://doe.house.gov'
                },
                'social' => { 'twitter' => 'repjanedoe', 'facebook' => 'repjanedoe' },
                'references' => { 'bioguide_id' => 'D000123', 'govtrack_id' => '412345' }
              }]
            }]
          }
        }]
      }
    }]
  }.to_json

  stub_request(:post, /api\.geocod\.io/)
    .to_return(
      status: 200,
      body: fake_geocodio_response,
      headers: { 'Content-Type' => 'application/json' }
    )
end
