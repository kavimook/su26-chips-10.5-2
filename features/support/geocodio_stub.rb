# frozen_string_literal: true

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

Before do
  # rubocop:disable Layout/LineLength
  stub_request(:post, /api\.geocod\.io/).to_return(
    status: 200,
    body: '{ "results": [{"response": {"results": [{"fields": {"congressional_districts": [{"name": "Congressional District 12", "district_number": 12, "ocd_id": "ocd-division/country:us/state:ca/cd:12", "current_legislators": [{"type": "representative", "bio": {"first_name": "Jane", "last_name": "Doe", "party": "Democrat", "gender": "F"}, "contact": {"url": "https://doe.house.gov", "address": "1234 Longworth House Office Building; Washington DC 20515", "phone": "202-225-0000"}, "social": {"twitter": "repjanedoe"}, "references": {"bioguide_id": "D000000", "govtrack_id": "412345"}}]}]}}]}}]}',
    headers: { 'Content-Type' => 'application/json' }
  )
  # rubocop:enable Layout/LineLength
end
