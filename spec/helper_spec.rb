require 'spec_helper.rb'

describe "helper methods" do
  include Rack::Test::Methods

  describe "get_v1" do
    subject { get_v1 "/" }

    it { should_not be_nil }

    its(:body) { should eq("Hello V1".to_json) }
  end

  describe "get_v2" do
    subject { get_v2 "/" }

    it { should_not be_nil }

    its(:body) { should eq("Hello V2".to_json) }
  end

end
