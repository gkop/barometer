require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "WebService::NoaaStation" do

  before(:each) do
    @latitude = "34.10"
    @longitude = "-118.41"
  end

  describe "and the class methods" do

    describe "fetch," do
      use_vcr_cassette

      it "requires latitude" do
        Barometer::WebService::NoaaStation.expects("_fetch").never
        Barometer::WebService::NoaaStation.fetch(nil,@longitude)
      end

      it "requires longitude" do
        Barometer::WebService::NoaaStation.expects("_fetch").never
        Barometer::WebService::NoaaStation.fetch(@latitude,nil)
      end

      it "queries" do
        Barometer::WebService::NoaaStation.fetch(@latitude,@longitude).should_not be_nil
      end

      it "returns a string" do
        Barometer::WebService::NoaaStation.fetch(@latitude,@longitude).is_a?(String).should be_true
        Barometer::WebService::NoaaStation.fetch(@latitude,@longitude).should == "KSMO"
      end

    end

  end

end
