require 'spec_helper'
require "cancan/matchers"

describe "Breeze::Admin::User" do
  describe "abilities" do
    subject { ability }
    let(:ability){ Breeze::Admin::Ability.new(user) }

    context "when is an merchant" do
      let(:user){ Factory(:merchant) }
      it{ should be_able_to(:manage, Breeze::Commerce::Store.new) }
    end

    context "when is an merchant" do
      let(:user){ Factory(:nonmerchant) }
      it{ should_not be_able_to(:manage, Breeze::Commerce::Store.new) }
    end

  end
end