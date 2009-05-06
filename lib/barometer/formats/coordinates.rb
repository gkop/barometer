module Barometer
  #
  # Format: Coordinates
  #
  # eg. 123.1234,-123.123
  #
  # This class is used to determine if a query is a
  # :coordinates and how to convert to :coordinates.
  #
  class Query::Coordinates < Query::Format
  
    def self.format; :coordinates; end
    def self.regex; /^[-]?[0-9\.]+[,]{1}[-]?[0-9\.]+$/; end
    def self.convertable_formats
      [:short_zipcode, :zipcode, :postalcode, :weather_id, :coordinates, :icao, :geocode]
    end
    
    # convert to this format, X -> :coordinates
    #
    def self.to(original_query)
      raise ArgumentError unless is_a_query?(original_query)
    #   return nil unless converts?(original_query)
      converted_query = Barometer::Query.new

      # pre-convert
      #
      pre_query = nil
      if original_query.format == :weather_id
        pre_query = Barometer::Query::WeatherID.reverse(original_query)
      end
      
      # convert & adjust
      #
      converted_query = Barometer::Query::Geocode.geocode(pre_query || original_query)
      converted_query.q = converted_query.geo.coordinates if converted_query.geo
      converted_query.format = format

      converted_query
    end

  end
end