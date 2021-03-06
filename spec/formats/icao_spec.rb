require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Query::Icao" do
  
  before(:each) do
    @valid = "KSFO"
    @invalid = "invalid"
  end
  
  describe "and class methods" do
    
    it "returns a format" do
      Barometer::Query::Format::Icao.format.should == :icao
    end
    
    it "returns a country" do
      Barometer::Query::Format::Icao.country_code.should be_nil
      Barometer::Query::Format::Icao.country_code("KSFO").should == "US"
      Barometer::Query::Format::Icao.country_code("CYYC").should == "CA"
      Barometer::Query::Format::Icao.country_code("ETAA").should == "DE"
    end
    
    it "returns a regex" do
      Barometer::Query::Format::Icao.regex.should_not be_nil
      Barometer::Query::Format::Icao.regex.is_a?(Regexp).should be_true
    end
    
    it "returns the convertable_formats" do
      Barometer::Query::Format::Icao.convertable_formats.should_not be_nil
      Barometer::Query::Format::Icao.convertable_formats.is_a?(Array).should be_true
      Barometer::Query::Format::Icao.convertable_formats.should == []
    end
    
    describe "is?," do
      
      it "recognizes a valid format" do
        Barometer::Query::Format::Icao.is?(@valid).should be_true
      end
      
      it "recognizes non-valid format" do
        Barometer::Query::Format::Icao.is?(@invalid).should be_false
      end
      
    end
  
    it "stubs to" do
      Barometer::Query::Format::Icao.to.should be_nil
    end
    
    it "stubs convertable_formats" do
      Barometer::Query::Format::Icao.convertable_formats.should == []
    end
    
    it "doesn't convert" do
      query = Barometer::Query.new(@valid)
      Barometer::Query::Format::Icao.converts?(query).should be_false
    end
    
  end
  
end