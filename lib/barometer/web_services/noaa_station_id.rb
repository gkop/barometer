module Barometer
  #
  # Web Service: NOAA Station ID
  #
  # uses noaa to find the closest station id
  #
  class WebService::NoaaStation < WebService
    
    # get the closest station id for given coordinates
    #
    def self.fetch(latitude, longitude)
      begin
        require 'nokogiri'
      rescue LoadError
        puts "\n****\nTo use this functionality you will need to install Nokogiri >= 1.3.3\n****\n\n"
        return nil
      end
      
      puts "fetching NOAA station ID near #{latitude}, #{longitude}" if Barometer::debug?
      return nil unless latitude && longitude
      _fetch_via_noaa(latitude, longitude)
    end
    
    # http://forecast.weather.gov/MapClick.php?textField1=LATITUDE&textField2=LONGITUDE
    def self._fetch_via_noaa(latitude, longitude)
      response = self.get(
        "http://forecast.weather.gov/MapClick.php?",
        :query => { :textField1 => latitude, :textField2 => longitude },
        :format => :html,
        :timeout => Barometer.timeout
      )
      # parse the station id from the given page
      station_id = nil
      begin
        doc = Nokogiri::HTML.parse(response.body)
        if doc && (link = doc.search("a[href*='http://www.weather.gov/data/obhistory/']")).any?
          begin
            station_id ||= link.last.attr("href").match(/.*\/(.*).html/)[1]
          rescue
          end
        elsif doc && (link = doc.search("a[href*='http://www.wrh.noaa.gov/mesowest/getobext.php']")).any?
          begin
            station_id = link.last.attr("href").match(/sid=(\w+)&/)[1]
          rescue
          end
        end
      rescue
        puts "[ERROR] finding NOAA station near #{latitude}, #{longitude}" if Barometer::debug?
      end
      station_id
    end
    
  end
end
