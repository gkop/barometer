require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :fakeweb
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end
