# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '.nav_items' do
    it 'includes a Bills entry' do
      titles = described_class.nav_items.map { |item| item[:title] }
      expect(titles).to include('Bills')
    end

    it 'points the Bills entry at the bills index' do
      bills = described_class.nav_items.find { |item| item[:title] == 'Bills' }
      expect(bills[:link]).to eq('/bills')
    end
  end

  describe '.active' do
    it 'highlights the nav item matching the current controller' do
      expect(described_class.active('bills', '/bills')).to eq('bg-primary-active')
    end

    it 'returns no class for a non-matching controller' do
      expect(described_class.active('map', '/bills')).to eq('')
    end
  end
end