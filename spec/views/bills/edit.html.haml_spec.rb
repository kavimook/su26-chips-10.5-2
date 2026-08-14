require 'rails_helper'

RSpec.describe "bills/edit", type: :view do
  let(:bill) {
    Bill.create!()
  }

  before(:each) do
    assign(:bill, bill)
  end

  it "renders the edit bill form" do
    render

    assert_select "form[action=?][method=?]", bill_path(bill), "post" do
    end
  end
end
