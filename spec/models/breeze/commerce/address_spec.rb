require 'spec_helper'

describe Breeze::Commerce::Address do

  before :each do
    @customer = create(:customer, shipping_address: FactoryGirl.build(:address) )
    @shipping_address = @customer.shipping_address
  end

  it "has a valid factory" do
    @shipping_address.should be_valid
  end

  describe "equivalence" do
    before :each do
      @customer.billing_address = @customer.shipping_address.dup
      @billing_address = @customer.billing_address
    end
    it "is equivalent to another address with the same field values" do
      @shipping_address.should eq @billing_address
    end
    it "is not equivalent if name field is different" do
      @billing_address.name = "a different name"
      @shipping_address.should_not eq @billing_address
    end
    it "is not equivalent if address field is different" do
      @billing_address.address = "a different address"
      @shipping_address.should_not eq @billing_address
    end
    it "is not equivalent if city field is different" do
      @billing_address.city = "a different city"
      @shipping_address.should_not eq @billing_address
    end
    it "is not equivalent if state field is different" do
      @billing_address.state = "a different state"
      @shipping_address.should_not eq @billing_address
    end
    it "is not equivalent if postcode field is different" do
      @billing_address.postcode = "a different postcode"
      @shipping_address.should_not eq @billing_address
    end
    it "is not equivalent if country field is different" do
      @billing_address.country = "a different country"
      @shipping_address.should_not eq @billing_address
    end
    it "is not equivalent if phone field is different" do
      @billing_address.phone = "a different phone"
      @shipping_address.should_not eq @billing_address
    end
  end

end