require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data("<ENCODED AUTH HEADER>") do |interaction|
    interaction.request.headers["Authorization"].first
  end

  c.register_request_matcher(:travis_api_request) do |actual, playback|
    actual_uri = URI.parse(actual.uri)
    actual.method == playback.method && actual_uri.path =~ /\A\/repo\/.+\/requests\z/
  end
end

RSpec.configure do |config|
  config.around(:vcr => true) do |example|
    cassette = example.metadata[:cassette] || raise(ArgumentError, "You must specify a cassette")
    vcr_options = example.metadata[:vcr_options] || {}
    VCR.use_cassette(cassette, vcr_options) { example.run }
  end
end
