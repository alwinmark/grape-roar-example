shared_examples "v1 ad route" do |ressource_version|

  describe "get" do

    describe "/ads" do

      let(:response) { self.send("get_#{ressource_version}", "/ads") }

      subject { response }

      it_behaves_like "json response"

      describe "json object" do
        let(:object) { JSON.parse response.body }
        subject { object }

        its(["ads"]) { should be_a(Array) }

        describe "ads" do
          subject { object["ads"] }

          context "empty ads" do
            it { should be_empty }
          end

          context "with one Element" do
            before(:all) do
              Ad.create(id: 1, name: "ad1", image_url: "url", company_id: 1)
            end

            after(:all) do
              Ad.all.destroy()
            end

            it { should have(1).items }

            describe "ad" do
              subject { object["ads"][0] }
              it_behaves_like "v1 ad", 1, "ad1", "url", 1
            end
          end
        end
      end
    end

    describe "ads/:id" do
      before(:all) do
        Ad.create(id: 1, name: "ad1", image_url: "url", company_id: 1)
      end

      after(:all) do
        Ad.all.destroy
      end

      let(:response) { self.send("get_#{ressource_version}", "/ads/1") }
      subject { response }

      it_behaves_like "json response"

      describe "JSON object" do
        subject { JSON.parse response.body }
        it_behaves_like "v1 ad", 1, "ad1", "url", 1
      end
    end
  end

  describe "post" do
    before(:all) do
      @response = self.send("post_#{ressource_version}", "/ads", name: "new Ad", image_url: "some url", company_id: "1")
    end

    after(:all) do
      Ad.all.destroy
    end

    describe "response" do
      subject { @response }

      it_behaves_like "json response"

      describe "JSON object" do
        subject { JSON.parse @response.body }

        it_behaves_like "v1 ad", nil, "new Ad", "some url", 1
      end
    end

    describe "saved object" do
      subject { Ad.first }

      its(:name) { should eq("new Ad") }
      its(:image_url) { should eq("some url") }
      its(:company_id) { should eq(1) }
    end
  end
end

shared_examples "v1 ad" do |id, name, image_url, company_id|
  its(["id"]) { should eq(id) } unless id.nil?
  its(["name"]) { should eq(name) }
  its(["image_url"]) { should eq(image_url) }

  its(["_links"]) { should be_a(Hash) }

  if id.nil?
    it { should have_link("self") }
  else
    it { should have_link("self").with_route("/ads/#{id}") }
  end
  it { should have_link("all").with_route("/ads") }
  it { should have_link("company").with_route("/companies/#{company_id}") }
end
