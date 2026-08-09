def legislator(type:, first_name:, last_name:, party:, bioguide_id:, govtrack_id:)
  {
    "type" => type,
    "bio" => { "first_name" => first_name, "last_name" => last_name, "party" => party },
    "references" => { "bioguide_id" => bioguide_id, "govtrack_id" => govtrack_id }
  }
end

CA_SENATOR_PADILLA = legislator(type: "senator", first_name: "Alejandro", last_name: "Padilla",
                                 party: "Democrat", bioguide_id: "S-CA-1", govtrack_id: "900001")
CA_SENATOR_SCHIFF = legislator(type: "senator", first_name: "Adam", last_name: "Schiff",
                                party: "Democrat", bioguide_id: "S-CA-2", govtrack_id: "900002")

# Scenario 1 Steps
Given('the Civic API returns Kern County officials for {string}') do |address|
  house_rep = legislator(type: "representative", first_name: "Vince", last_name: "Fong",
                          party: "Republican", bioguide_id: "H-CA-20", govtrack_id: "900101")
  payload = civic_payload_for(district_number: 20, house_official: house_rep,
                              senator_officials: [CA_SENATOR_PADILLA, CA_SENATOR_SCHIFF])
  allow(Representative).to receive(:geocodio_search).with(address).and_return(payload)
end

When('I visit the search page for {string}') do |address|
  visit search_representatives_path(address: address)
end

Then('I should see representatives for {string}') do |name|
  expect(page).to have_content(name)
end

# Scenario 2 Steps
Given('the Civic API returns Santa Clara County officials for {string}') do |address|
  house_rep = legislator(type: "representative", first_name: "Zoe", last_name: "Lofgren",
                          party: "Democrat", bioguide_id: "H-CA-18", govtrack_id: "900102")
  payload = civic_payload_for(district_number: 18, house_official: house_rep,
                              senator_officials: [CA_SENATOR_PADILLA, CA_SENATOR_SCHIFF])
  allow(Representative).to receive(:geocodio_search).with(address).and_return(payload)
end