# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bills/edit' do
  let(:bill) do
    Bill.create!(
      title: 'MyString',
      congress: 1,
      number: 1,
      original_chamber: 'house',
      type: 'hr',
      summary: 'MyText'
    )
  end

  before do
    assign(:bill, bill)
  end

  it 'renders the edit bill form' do
    render

    assert_select 'form[action=?][method=?]', bill_path(bill), 'post' do
      assert_select 'input[name=?]', 'bill[title]'

      assert_select 'input[name=?]', 'bill[congress]'

      assert_select 'input[name=?]', 'bill[number]'

      assert_select 'input[name=?]', 'bill[original_chamber]'

      assert_select 'input[name=?]', 'bill[type]'

      assert_select 'textarea[name=?]', 'bill[summary]'
    end
  end
end
