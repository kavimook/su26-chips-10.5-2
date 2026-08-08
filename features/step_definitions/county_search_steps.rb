Given('a state {string} with symbol {string} exists') do |name, symbol|
  @state = State.create!(name: name, symbol: symbol, fips_code: 20,
                          is_territory: 0, lat_min: 0, lat_max: 0, long_min: 0, long_max: 0)
end

Given('a county {string} exists in {string}') do |county_name, state_name|
  state = State.find_by!(name: state_name)
  @county = County.create!(name: county_name, fips_code: 15, fips_class: 'H1', state: state)
end

Given('Geocodio returns {string} as a representative for that search') do |full_name|
  first_name, last_name = full_name.split(' ', 2)
  legislator = {
    'bio' => { 'first_name' => first_name, 'last_name' => last_name },
    'type' => 'representative', 'govtrack_id' => '412345', 'party' => 'Democratic'
  }
  response = { 'results' => [{ 'response' => { 'results' => [{ 'fields' =>
    { 'congressional_districts' => [{ 'current_legislators' => [legislator] }] } }] } }] }
  allow(Representative).to receive(:geocodio_search).and_return(response)
end

When('I visit the search page for {string}') do |address|
  visit "/search/#{ERB::Util.url_encode(address)}"
end

Then('I should see {string} in the representatives table') do |name|
  expect(page).to have_content(name)
end