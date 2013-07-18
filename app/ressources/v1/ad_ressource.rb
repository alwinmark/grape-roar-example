module V1
  module AdRepresenter
    include Roar::Representer::JSON::HAL

    property :id
    property :name
    property :image_url

    link :self do "http://localhost:9292/ads/#{id}" end
    link :all do "http://localhost:9292/ads" end
    link :company do "http://localhost:9292/companies/#{company_id}" end

  end

  module AdCollectionRepresenter
    include Roar::Representer::JSON::HAL

    def ads
      all
    end

    collection :ads, extend: AdRepresenter
  end

  class AdRessource < Grape::API

    resource :ads do
      get do
        ads = Ad.all
        ads.extend AdCollectionRepresenter
        ads
      end
    end
  end

end
