# frozen_string_literal: true

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

Before do
  stub_request(:get, /api\.congress\.gov/).to_return(
    status: 200,
    body: '{"bills": []}',
    headers: { 'Content-Type' => 'application/json' }
  )
end
