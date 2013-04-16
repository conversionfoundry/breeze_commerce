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

    context "when user is an admin" do
      it "can manage store" do
        admin = FactoryGirl.create :admin
        ability = Breeze::Admin::Ability.new(admin)
        ability.should be_able_to :manage, @store
      end
    end

    context "when user is an editor" do
      it "can't manage store" do
        editor = FactoryGirl.create :editor
        ability = Breeze::Admin::Ability.new(editor)
        ability.should_not be_able_to :manage, @store
      end
    end

  end
end