require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Barometer

describe "NOAA" do

  before(:each) do
    @accepted_formats = [:zipcode, :coordinates]
  end

  describe "the class methods" do

    it "defines accepted_formats" do
      WeatherService::Noaa._accepted_formats.should == @accepted_formats
    end

    it "defines source_name" do
      WeatherService::Noaa._source_name.should == :noaa
    end

    it "defines fetch_current" do
      WeatherService::Noaa.respond_to?("_fetch_current").should be_true
    end

    it "defines fetch_forecast" do
      WeatherService::Noaa.respond_to?("_fetch_forecast").should be_true
    end

    it "defines get_all" do
      WeatherService::Noaa.respond_to?("_fetch").should be_true
    end

    describe "acceptable countries" do

      before(:each) do
        @query = Barometer::Query.new("90210")
        @measurement = Barometer::Measurement.new
      end

      it "accepts nil" do
        @query.country_code = nil
        WeatherService::Noaa._supports_country?(@query).should be_true
      end

      it "accepts blank" do
        @query.country_code = ""
        WeatherService::Noaa._supports_country?(@query).should be_true
      end

      it "accepts US" do
        @query.country_code = "US"
        WeatherService::Noaa._supports_country?(@query).should be_true
      end

      it "rejects other" do
        @query.country_code = "CA"
        WeatherService::Noaa._supports_country?(@query).should be_false
      end

    end

  end

  describe "building the current data" do

    it "defines the build method" do
      WeatherService::Noaa.respond_to?("_build_current").should be_true
    end

    it "requires Hash input" do
      lambda { WeatherService::Noaa._build_current }.should raise_error(ArgumentError)
      lambda { WeatherService::Noaa._build_current({}) }.should_not raise_error(ArgumentError)
    end

    it "returns Barometer::CurrentMeasurement object" do
      current = WeatherService::Noaa._build_current({})
      current.is_a?(Measurement::Result).should be_true
    end

  end

  describe "building the forecast data" do

    it "defines the build method" do
      WeatherService::Noaa.respond_to?("_build_forecast").should be_true
    end

    it "requires Hash input" do
      lambda { WeatherService::Noaa._build_forecast }.should raise_error(ArgumentError)
      lambda { WeatherService::Noaa._build_forecast({}) }.should_not raise_error(ArgumentError)
    end

    it "returns Array object" do
      current = WeatherService::Noaa._build_forecast({})
      current.is_a?(Array).should be_true
    end

  end

  describe "when measuring" do

    before(:each) do
      @query = Barometer::Query.new("90210")
      @measurement = Barometer::Measurement.new
    end

    describe "all" do
      use_vcr_cassette

      it "responds to _measure" do
        Barometer::WeatherService::Noaa.respond_to?("_measure").should be_true
      end

      it "requires a Barometer::Measurement object" do
        lambda { Barometer::WeatherService::Noaa._measure(nil, @query) }.should raise_error(ArgumentError)
        lambda { Barometer::WeatherService::Noaa._measure("invalid", @query) }.should raise_error(ArgumentError)

        lambda { Barometer::WeatherService::Noaa._measure(@measurement, @query) }.should_not raise_error(ArgumentError)
      end

      it "requires a Barometer::Query query" do
        lambda { Barometer::WeatherService::Noaa._measure }.should raise_error(ArgumentError)
        lambda { Barometer::WeatherService::Noaa._measure(@measurement, 1) }.should raise_error(ArgumentError)

        lambda { Barometer::WeatherService::Noaa._measure(@measurement, @query) }.should_not raise_error(ArgumentError)
      end

      it "returns a Barometer::Measurement object" do
        result = Barometer::WeatherService::Noaa._measure(@measurement, @query)
        result.is_a?(Barometer::Measurement).should be_true
        result.current.is_a?(Barometer::Measurement::Result).should be_true
        result.forecast.is_a?(Barometer::Measurement::ResultArray).should be_true
      end

    end

  end

  describe "overall data correctness" do
    use_vcr_cassette

    before(:each) do
      @query = Barometer::Query.new("90210")
      @measurement = Barometer::Measurement.new
    end

    it "should correctly build the data" do
      result = WeatherService::Noaa._measure(@measurement, @query)

      # build current
      @measurement.current.humidity.should be_a_kind_of(Fixnum)
      @measurement.current.condition.should == "Fair"
      @measurement.current.icon.should == "skc"
      @measurement.current.temperature.should be_a_kind_of(Data::Temperature)
      @measurement.current.dew_point.should be_a_kind_of(Data::Temperature)
      @measurement.current.wind.mph(false).should be_a_kind_of(Float)
      @measurement.current.wind.direction.should be_a_kind_of(String)
      @measurement.current.wind.degrees.should be_a_kind_of(Fixnum)
      @measurement.current.pressure.should be_a_kind_of(Data::Pressure)

      # build station
      @measurement.station.id.should == "KSMO"
      @measurement.station.name.should == "Santa Monica Muni, CA"
      @measurement.station.city.should == "Santa Monica Muni"
      @measurement.station.state_code.should == "CA"
      @measurement.station.country_code.should == "US"
      @measurement.station.latitude.to_f.should == 34.03
      @measurement.station.longitude.to_f.should == -118.45

      # builds location
      @measurement.location.city.should == "Santa Monica Muni"
      @measurement.location.state_code.should == "CA"
      @measurement.location.country_code.should == "US"

      # builds forecasts
      @measurement.forecast.size.should == 7

      @measurement.forecast[0].valid_start_date.should be_a_kind_of(Data::LocalDateTime)
      @measurement.forecast[0].valid_end_date.should be_a_kind_of(Data::LocalDateTime)
      @measurement.forecast[0].condition.should be_a_kind_of(String)
      @measurement.forecast[0].icon.should be_a_kind_of(String)
      @measurement.forecast[0].high.should be_a_kind_of(Data::Temperature)
      @measurement.forecast[0].low.should be_a_kind_of(Data::Temperature)

      # builds local time
      # @measurement.measured_at.to_s.should == "10:51 am"
      # @measurement.current.current_at.to_s.should == "10:51 am"

      # builds timezone
      @measurement.timezone.code.should == Data::Zone.new("PDT").code
      @measurement.timezone.offset.should == Data::Zone.new("PDT").offset
      @measurement.timezone.today.should == Data::Zone.new("PDT").today
    end

  end

end
