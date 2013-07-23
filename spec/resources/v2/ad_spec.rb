require "spec_helper"

describe "ad interface v2" do
  include Rack::Test::Methods

  it_behaves_like "v1 ad route", "v2"
end
