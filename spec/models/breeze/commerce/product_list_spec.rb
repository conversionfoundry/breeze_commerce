require 'spec_helper'

describe Breeze::Commerce::ProductList do
  subject { create(:product_list) }
  let(:product) { create(:product) }
  let(:tag) { create(:tag) }
  let(:tag_two) { create(:tag) }
  

  describe "#products" do
    context "by tags" do
      before(:each) do
        subject.should_receive(:list_type) { 'by_tags' }
        subject.tag_ids.push tag
        subject.stub(:products) { [product] }
      end

    end
  end
end
