require 'spec_helper'

describe GolfCourse do
  
  describe "factories" do
    it "valid :golf_course" do
      Factory.save(:golf_course).should be_valid
    end
  end
  
  describe "associations" do
    before(:each) { @golf_course = Factory.save(:golf_course) }
    context "" do
      it "" do
        @golf_course
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
    context "new golf_course" do
      before(:each) { @golf_course = Factory.save(:golf_course) }
      it "" do
        @golf_course
      end
    end
  end
  
  describe "validations on" do
    context "new :golf_course" do
      it "requires a name" do
        Factory.save(:golf_course, :name => '').should have(1).error_on(:name)
      end
      it "requires a location" do
        Factory.save(:golf_course, :location => '').should have(1).error_on(:location)
      end
    end
  end
  
  describe "class methods" do
    context "#" do
      it "" do
        GolfCourse
      end
    end
  end
  
  describe "instance methods" do
    before(:each) { @golf_course = Factory.save(:golf_course) }
    context "#" do
      it "" do
        @golf_course
      end
    end
  end
  
end
