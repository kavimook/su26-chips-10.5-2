require 'rails_helper'

RSpec.describe "bills/show", type: :view do
  before(:each) do
    assign(:bill, Bill.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
