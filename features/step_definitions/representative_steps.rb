# frozen_string_literal: true

Given /^a representative named "([^"]*)" exists with a full profile$/ do |name|
  create(:representative,
         name: name,
         title: 'Representative',
         party: 'Democrat',
         address: '123 Main St',
         phone: '555-1234',
         website: 'https://doe.house.gov',
         twitter: 'repjanedoe',
         facebook: 'repjanedoe',
         birthday: '1970-01-01',
         gender: 'F',
         photo_url: 'https://unitedstates.github.io/images/congress/225x275/D000123.jpg')
end

Given /^a representative named "([^"]*)" exists with only a name and title$/ do |name|
  create(:representative, name: name, title: 'Representative')
end

When /^I visit the profile page for "([^"]*)"$/ do |name|
  visit representative_path(Representative.find_by!(name: name))
end

Then /^I should see a photo for the representative$/ do
  expect(page).to have_css('img.img-fluid.shadow.rounded')
end
