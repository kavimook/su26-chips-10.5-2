module SenatorSteps
  # Builds a Civic-API-shaped congressional_districts payload for one district.
  def civic_payload_for(district_number:, senator_officials:)
    {
      "results" => [{
        "response" => {
          "results" => [{
            "fields" => {
              "congressional_districts" => [{
                "name" => "Congressional District #{district_number}",
                "district_number" => district_number,
                "ocd_id" => "ocd-division/country:us/state:ca/cd:#{district_number}",
                "current_legislators" => senator_officials
              }]
            }
          }]
        }
      }]
    }
  end

  # rubocop:disable Metrics/ParameterLists
  def legislator(type:, first_name:, last_name:, party:, bioguide_id:, govtrack_id:)
  # rubocop:enable Metrics/ParameterLists    {
      "type" => type,
      "bio" => { "first_name" => first_name, "last_name" => last_name, "party" => party },
      "references" => { "bioguide_id" => bioguide_id, "govtrack_id" => govtrack_id }
    }
  end

  # The two CA Senators -- same person, same ocdid, in both counties' payloads.
  def ca_senator_padilla
    legislator(type: "senator", first_name: "Alejandro", last_name: "Padilla",
               party: "Democrat", bioguide_id: "S-CA-1", govtrack_id: "900001")
  end

  def ca_senator_schiff
    legislator(type: "senator", first_name: "Adam", last_name: "Schiff",
               party: "Democrat", bioguide_id: "S-CA-2", govtrack_id: "900002")
  end
end

World(SenatorSteps)

Given('the Civic API returns Kern County officials for {string}') do |address|
  payload = civic_payload_for(district_number: 20,
                              senator_officials: [ca_senator_padilla, ca_senator_schiff])
  allow(Representative).to receive(:geocodio_search).with(address).and_return(payload)
end

Given('the Civic API returns Santa Clara County officials for {string}') do |address|
  payload = civic_payload_for(district_number: 18,
                              senator_officials: [ca_senator_padilla, ca_senator_schiff])
  allow(Representative).to receive(:geocodio_search).with(address).and_return(payload)
end

Then('I should see senators for {string}') do |name|
  expect(page).to have_content(name)
end