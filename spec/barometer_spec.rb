require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Barometer" do

  before(:each) do
    @config_hash = { 1 => [:wunderground] }
    @yahoo_key = YAHOO_KEY
  end

  describe "and class methods" do

    it "defines selection" do
      Barometer::Base.respond_to?("config").should be_true
      Barometer::Base.config.should == { 1 => [:wunderground] }
      Barometer::Base.config = { 1 => [:yahoo] }
      Barometer::Base.config.should == { 1 => [:yahoo] }
      Barometer.config = @config_hash
    end

    it "returns a Weather Service driver" do
      Barometer.source(:wunderground).should == Barometer::WeatherService::Wunderground
    end

    it "deprecates the Google geocoding API key reader" do
      Barometer.should_receive(:warn)
      Barometer.respond_to?("google_geocode_key").should be_true
      Barometer.google_geocode_key
    end

    it "deprecates the Google geocoding API key writer" do
      Barometer.should_receive(:warn)
      Barometer.respond_to?("google_geocode_key=").should be_true
      Barometer.google_geocode_key= 'KEY'
    end

    it "sets the Placemaker Yahoo! app ID" do
      Barometer.respond_to?("yahoo_placemaker_app_id").should be_true
      Barometer.yahoo_placemaker_app_id = nil
      Barometer.yahoo_placemaker_app_id.should be_nil
      Barometer.yahoo_placemaker_app_id = @yahoo_key
      Barometer.yahoo_placemaker_app_id.should == @yahoo_key
    end

    it "forces the geocoding of queries" do
      Barometer.respond_to?("force_geocode").should be_true
      Barometer.force_geocode.should be_false
      Barometer.force_geocode = true
      Barometer.force_geocode.should be_true
    end


  end


end
