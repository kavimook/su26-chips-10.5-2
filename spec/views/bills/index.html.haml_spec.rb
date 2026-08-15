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
end
