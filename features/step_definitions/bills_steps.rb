# frozen_string_literal: true

Given('congress.gov has recent bills including {string}') do |title|
  stub_request(:get, 'https://api.congress.gov/v3/bill')
    .with(query: hash_including('limit' => '50'))
    .to_return(
      status: 200,
      body: { bills: [{ title: title, congress: 119, number: 1, type: 'HR' }] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end

Given('congress.gov has a bill {string} for congress {string} type {string}') do |title, congress, type|
  stub_request(:get, "https://api.congress.gov/v3/bill/#{congress}/#{type}")
    .to_return(
      status: 200,
      body: { bills: [{ title: title, congress: congress.to_i, number: 2, type: type.upcase }] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end
