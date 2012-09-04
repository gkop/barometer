require 'rubygems'
require 'rspec'
require 'mocha'
require 'cgi'
require 'pry'
require 'pry-nav'

require File.expand_path(File.dirname(__FILE__) + '/fakeweb_helper')

$:.unshift((File.join(File.dirname(__FILE__), '..', 'lib')))
require 'barometer'

#Barometer.debug!
Barometer.yahoo_placemaker_app_id = "YAHOO"

RSpec.configure do |config|
end
