module V2
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

      route_param :id do
        get do
          ad = Ad.get(params[:id])
          ad.extend AdRepresenter
          ad
        end
      end

      get do
        ads = Ad.all
        ads.extend AdCollectionRepresenter
        ads
      end

      params do
        requires :name, type: String, desc:"Ad name"
        requires :image_url, type: String, desc:"Image URL"
        requires :company_id, type: Integer, desc:"ID of a company"
      end
      post do
        attributes = [:name, :image_url, :company_id].each_with_object({}) do |key, object|
          object[key] = params[key]
          object
        end

        ad = Ad.create(attributes)
        ad.extend AdRepresenter
        ad
      end
    end
  end

end
