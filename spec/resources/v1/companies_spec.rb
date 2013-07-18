require "spec_helper"

describe "companies" do
  include Rack::Test::Methods

  describe "get" do
    describe "companies/:id/full" do
      subject { get_v1 "/companies/1/full" }

      before(:all) do
        old_company = Company.create(id: 1, name: "company1", credit_card_number: "not defined yet")
        CompanyV1.create(industry: "IT Consulting", company_id: old_company.id)
      end

      after(:all) do
        Company.all.destroy
        CompanyV1.all.destroy
      end

      it { should_not be_nil }

      describe "response.body" do

        it "should be valid json" do
          expect{ JSON.parse get_v1("/companies/1/full").body }.to_not raise_error
        end

        describe "json object" do
          subject { JSON.parse get_v1("/companies/1/full").body }

          its(["id"]) { should eq(1) }

          its(["name"]) { should eq("company1") }

          its(["credit_card_number"]) { should be_nil }

          its(["industry"]) { should eq("IT Consulting") }

          describe "_embedded" do
            subject { JSON.parse(get_v1("/companies/1/full").body)["_embedded"] }

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
                subject { JSON.parse(get_v1("/companies/1/full").body)["_embedded"]["ads"][0] }

                its(["id"]) { should eq(1) }

                its(["name"]) { should eq("ad1") }

                its(["image_url"]) { should eq("url") }
              end
            end
          end
        end
      end
    end

    describe "/companies/:id" do
      subject { get_v1 "/companies/1" }

      before(:all) do
        old_company = Company.create(id: 1, name: "company1", credit_card_number: "not defined yet")
        CompanyV1.create(industry: "IT Consulting", company_id: old_company.id)
      end

      after(:all) do
        Company.all.destroy
        CompanyV1.all.destroy
      end

      it { should_not be_nil }

      describe "response.body" do

        it "should be valid json" do
          expect{ JSON.parse get_v1("/companies/1").body }.to_not raise_error
        end

        describe "json object" do
          subject { JSON.parse get_v1("/companies/1").body }

          its(["id"]) { should eq(1) }

          its(["name"]) { should eq("company1") }

          its(["credit_card_number"]) { should be_nil }

          its(["_embedded"]) { should be_nil }
        end
      end
    end
  end

  describe "post" do
    describe "/companies?name=test&industry=IT Consulting" do
      subject { post_v1 "/companies", name: "test", industry: "IT Consulting" }

      after(:each) do
        Company.all.destroy
        CompanyV1.all.destroy
      end

      it { should_not be_nil }

      describe "json object" do
        subject { JSON.parse post_v1("/companies", name: "test", industry: "IT Consulting").body }

        its(["name"]) { should eq("test") }

        its(["industry"]) { should eq("IT Consulting") }
      end

      describe "created company" do
        subject { Company.first }

        before(:each) do
          post_v1 "/companies", name: "test", industry: "IT Consulting"
        end

        its(:name) { should eq("test") }

        its(:credit_card_number) { should eq("Not defined yet") }
      end

      describe "created company_v1" do
        subject { CompanyV1.first }

        before(:each) do
          post_v1 "/companies", name: "test", industry: "IT Consulting"
        end

        its(:company_id) { should_not be_nil }

        its(:industry) { should eq("IT Consulting") }

      end
    end
  end



  context "compatibilty of new models" do
    describe "show created v2 created company" do
      subject { get_v1 "/companies/1" }

      before(:all) do
        DataMapper.auto_migrate!
        post_v2 "/companies", name: "v2", credit_card_number: "1234"
      end

      after(:all) do
        Company.all.destroy
        CompanyV1.all.destroy
      end

      it { should_not be_nil }

      it "should be parseable JSON" do
        expect{ JSON.parse subject.body}.to_not raise_error
      end

      describe "JSON Object" do
        subject { JSON.parse (get_v1 "/companies/1").body }

        its(["name"]) { should eq("v2") }
      end
    end

  end
end
