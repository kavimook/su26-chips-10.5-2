# Scenario 1 Steps
Given('I visit the search page for {string}') do |address|
  # Adjust this path if your route expects something different (like ?county=)
  visit search_representatives_path(address: address)
end

Then('I should see representatives for {string}') do |county_name|
  # Checks if the results table renders
  expect(page).to have_content(county_name)
  # You can also add checks for specific representative names here!
end

# Scenario 2 Steps
Given('I visit the state map page for {string}') do |state_symbol|
  visit state_map_path(state_symbol: state_symbol)
end

Then('the map should have a clickable element for {string}') do |county_name|
  # Asserts that the path element for the county exists on the page and has the correct data
  expect(page).to have_css("path[data-county-name='#{county_name}']")
end