# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BillsHelper do
  let(:api_bill) do
    {
      'congress' => 119,
      'number' => '3076',
      'originChamber' => 'House',
      'title' => 'Postal Service Reform Act of 2022',
      'type' => 'HR',
      'latestAction' => { 'actionDate' => '2024-04-06',
                          'text' => 'Became Public Law No: 117-108' }
    }
  end

  describe '#bill_number_label' do
    it 'joins the type shorthand and the bill number' do
      expect(helper.bill_number_label(api_bill)).to eq('HR 3076')
    end

    it 'shortens a senate resolution type' do
      expect(helper.bill_number_label(api_bill.merge('type' => 'SRES', 'number' => '999')))
        .to eq('SR 999')
    end

    it 'falls back to the upcased code when the type is unrecognised' do
      expect(helper.bill_number_label(api_bill.merge('type' => 'xyz'))).to eq('XYZ 3076')
    end
  end

  describe '#bill_last_action' do
    it 'appends the formatted action date' do
      expect(helper.bill_last_action(api_bill))
        .to eq('Became Public Law No: 117-108 on Apr 6, 2024')
    end

    it 'returns an empty string when there is no latest action' do
      expect(helper.bill_last_action(api_bill.except('latestAction'))).to eq('')
    end

    it 'returns only the text when the date cannot be parsed' do
      action = { 'actionDate' => 'not-a-date', 'text' => 'Referred to committee' }
      expect(helper.bill_last_action(api_bill.merge('latestAction' => action)))
        .to eq('Referred to committee')
    end
  end

  describe '#bill_save_params' do
    it 'downcases the chamber and type so they satisfy Bill validations' do
      expect(helper.bill_save_params(api_bill)[:bill])
        .to include(original_chamber: 'house', type: 'hr')
    end

    it 'produces attributes a Bill accepts' do
      expect(Bill.new(helper.bill_save_params(api_bill)[:bill])).to be_valid
    end
  end

  describe '#saved_bill_number_label' do
    it 'formats a Bill record the same way as an API result' do
      bill = Bill.new(type: 'sres', number: 999)
      expect(helper.saved_bill_number_label(bill)).to eq('SR 999')
    end
  end
end
