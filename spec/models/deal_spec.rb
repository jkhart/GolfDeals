require 'spec_helper'

describe Deal do
  
  describe "factories" do
    it "valid :deal" do
      Factory.save(:deal).should be_valid
    end
  end
  
  describe "associations" do
    before(:each) { @deal = Factory.save(:deal) }
    context "" do
      it "" do
        @deal
      end
    end
  end
  
  describe "scopes" do
    context "" do
      it "" do
      end
    end
  end

  describe "callbacks on" do
    context "new deal" do
      before(:each) { @deal = Factory.save(:deal) }
      it "" do
      end
    end
  end
  
  describe "validations on" do
    context "new :deal" do
      it "requires a tee time" do
        Factory.save(:deal, :tee_time => '').should have(1).error_on(:tee_time)
      end
      it "requires a url" do
        Factory.save(:deal, :url => '').should have(1).error_on(:url)
      end
      it "requires a cost" do
        Factory.save(:deal, :cost => '').should have(1).error_on(:cost)
      end
      it "requires a players" do
        Factory.save(:deal, :players => '').should have(1).error_on(:players)
      end
    end
  end
  
  describe "class methods" do
    context "#" do
      it "" do
        Deal
      end
    end
  end
  
  describe "instance methods" do
    before(:each) { @deal = Factory.save(:deal) }
    context "#" do
      it "" do
        @deal
      end
    end
  end
  
end
