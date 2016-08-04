require 'kinopoisk_parser'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.cassette_library_dir     = 'spec/fixtures'
  c.default_cassette_options = { record: :new_episodes }
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
