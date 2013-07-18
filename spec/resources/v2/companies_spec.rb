require "spec_helper"

describe "companies" do
  include Rack::Test::Methods

  describe "get" do
    describe "companies/:id" do
      subject { get_v2 "/companies/1" }

      before(:all) do
        Company.create(id: 1, name: "company1", credit_card_number: "1234")
      end

      after(:all) do
        Company.all.destroy
      end

      it { should_not be_nil }

      describe "response.body" do

        it "should be valid json" do
          expect{ JSON.parse get_v2("/companies/1").body }.to_not raise_error
        end

        describe "json object" do
          subject { JSON.parse get_v2("/companies/1").body }

          its(["id"]) { should eq(1) }

          its(["name"]) { should eq("company1") }

          its(["credit_card_number"]) { should eq("1234") }

          its(["industry"]) { should be_nil }

          describe "_embedded" do
            subject { JSON.parse(get_v2("/companies/1").body)["_embedded"] }

            context "with no ads" do

              its(["ads"]) { should eq([]) }
            end

            context "with one ad" do
              before(:all) do
                Ad.create(id: 1, name: "ad1", image_url: "url", company_id: 1)
              end

              after(:all) do
                Ad.all.destroy()
              end

              its(["ads"]) { should have(1).items }

              describe "ad" do
                subject { JSON.parse(get_v2("/companies/1").body)["_embedded"]["ads"][0] }

                its(["id"]) { should eq(1) }

                its(["name"]) { should eq("ad1") }

                its(["image_url"]) { should eq("url") }
              end
            end
          end
        end
      end
    end

    describe "/companies/:id/basic" do
      subject { get_v2 "/companies/1/basic" }

      before(:all) do
        Company.create(id: 1, name: "company1", credit_card_number: "1234")
      end

      after(:all) do
        Company.all.destroy
      end

      it { should_not be_nil }

      describe "response.body" do

        it "should be valid json" do
          expect{ JSON.parse get_v2("/companies/1/basic").body }.to_not raise_error
        end

        describe "json object" do
          subject { JSON.parse get_v2("/companies/1/basic").body }

          its(["id"]) { should eq(1) }

          its(["name"]) { should eq("company1") }

          its(["credit_card_number"]) { should eq("1234") }

          its(["_embedded"]) { should be_nil }
        end
      end
    end
  end

  describe "post" do
    describe "/companies?name=test&credit_card_number=1234" do
      subject { post_v2 "/companies", name: "test", credit_card_number: "1234" }

      after(:each) do
        Company.all.destroy
      end

      it { should_not be_nil }

      describe "json object" do
        subject { JSON.parse post_v2("/companies", name: "test", credit_card_number: "1234").body }

        its(["name"]) { should eq("test") }

        its(["credit_card_number"]) { should eq("1234") }
      end

      describe "created company" do
        subject { Company.first }

        before(:each) do
          post_v2 "/companies", name: "test", credit_card_number: "1234"
        end

        its(:name) { should eq("test") }

        its(:credit_card_number) { should eq("1234") }
      end
    end
  end
end
