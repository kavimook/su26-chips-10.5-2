# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bills/index' do
  before do
    assign(:bills, [
             Bill.create!(
               title: 'Title',
               congress: 2,
               number: 3,
               original_chamber: 'house',
               type: 'hr',
               summary: 'MyText'
             ),
             Bill.create!(
               title: 'Title',
               congress: 2,
               number: 3,
               original_chamber: 'house',
               type: 'hr',
               summary: 'MyText'
             )
           ])
  end

  it 'renders a list of bills' do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new('Title'), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('house'), count: 2
    assert_select cell_selector, text: Regexp.new('hr'), count: 2
    assert_select cell_selector, text: Regexp.new('MyText'), count: 2
  end

  context 'with congress.gov search results' do
    before do
      assign(:search_results,
             'bills' => [{
               'congress' => 119, 'number' => '3076', 'originChamber' => 'House',
               'title' => 'Postal Service Reform Act', 'type' => 'HR',
               'latestAction' => { 'actionDate' => '2024-04-06',
                                   'text' => 'Became Public Law No: 117-108' }
             }],
             'pagination' => { 'count' => 25_000 })
    end

    it 'shows how many results are displayed out of the total' do
      render
      expect(rendered).to include('Showing 1 of 25000 results')
    end

    it 'formats the number column as shorthand type and number' do
      render
      expect(rendered).to include('HR 3076')
    end

    it 'formats the last action with its date' do
      render
      expect(rendered).to include('Became Public Law No: 117-108 on Apr 6, 2024')
    end

    it 'renders a Save button for each result' do
      render
      expect(rendered).to include('Save')
    end
  end
end
