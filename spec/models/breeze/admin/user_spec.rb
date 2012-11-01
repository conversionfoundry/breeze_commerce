require 'spec_helper'
require "cancan/matchers"

describe "Breeze::Admin::User" do
  describe Breeze::Admin::Ability do
    # subject { ability }
    # let(:ability){ Breeze::Admin::Ability.new(user) }

    before :each do
      @store = FactoryGirl.create :store
    end

    context "when user is an merchant" do
      it "can manage store" do
        merchant = FactoryGirl.create :merchant
        ability = Breeze::Admin::Ability.new(merchant)
        ability.should be_able_to :manage, @store
      end
    end

    context "when user isn't a merchant" do
      it "can't manage store" do
        nonmerchant = FactoryGirl.create :nonmerchant 
        ability = Breeze::Admin::Ability.new(nonmerchant)
        ability.should_not be_able_to :manage, @store
      end
    end

  end
end