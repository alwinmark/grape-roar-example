shared_examples "json response" do

  describe "response" do
    it { should_not be_nil }

    describe "body" do
      it "should be parseable as JSON" do
        expect{ JSON.parse subject.body }.to_not raise_error
      end
    end
  end
end
