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

  stub_request(:get, %r{api\.congress\.gov/v3/bill/\d+/[a-z]+/\d+/summaries}).to_return(
    status:  200,
    body:    {
      summaries: [{
        actionDate: '2022-03-08',
        actionDesc: 'Passed Senate',
        text:       '<p>This bill addresses the finances and operations of the ' \
                    'U.S. Postal Service.</p>'
      }]
    }.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )
end
