require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr/cassette_library'
  c.hook_into :webmock
end