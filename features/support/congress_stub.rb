# frozen_string_literal: true

require 'webmock/cucumber'

Before do
  stub_request(:get, /api\.congress\.gov/).to_return(
    status:  200,
    body:    {
      bills:      [{
        congress:      119,
        number:        '3076',
        originChamber: 'House',
        title:         'Postal Service Reform Act of 2022',
        type:          'HR',
        latestAction:  { actionDate: '2024-04-06',
                         text: 'Became Public Law No: 117-108' }
      }],
      pagination: { count: 25_000 }
    }.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )
end
