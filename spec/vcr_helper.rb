require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
  c.register_request_matcher :weather_bug do |request_1, request_2|
    a = URI(request_1.uri)
    b = URI(request_2.uri)
    # check host minus leftmost domain component (which is API key)
    result = a.host.match(/\w+\.(.*)/)[1] == b.host.match(/\w+\.(.*)/)[1]
    result = result && a.path == b.path
    # check query string minus API key
    result = result && (a.query.match(/ACode=\w+(.*)/)[1] ==
                        b.query.match(/ACode=\w+(.*)/)[1])
    result
  end
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end
