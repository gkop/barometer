yml_file = File.expand_path(File.dirname(__FILE__) + '/sensitive.yml')

begin
  options = YAML::load(File.read(yml_file))
  API_KEYS = options
  WEATHERBUG_CODE = API_KEYS["weather_bug"]["code"]
rescue Exception => ex
  WEATHERBUG_CODE = "stewie"
  puts "Error parsing sensitive options from yaml file #{yml_file}: #{ex.inspect}"
end

