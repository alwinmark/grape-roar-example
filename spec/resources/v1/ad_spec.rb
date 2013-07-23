require "spec_helper"

describe "ad interface v1" do
  include Rack::Test::Methods

  it_behaves_like "v1 ad route", "v1"
end
