module V1

  module CompanyRepresenter
    include Roar::Representer::JSON::HAL

    property :id
    property :name
    property :industry

    def industry
      legacy_company = CompanyV1.get(id)
      if legacy_company.nil?
        "undescribed"
      else
        CompanyV1.get(id).industry
      end
    end

    link :self do "http://localhost:9292/companies/#{id}" end
    link :full do "http://localhost:9292/companies/#{id}/full" end
  end

  module CompanyEmbeddedRepresenter
    include Roar::Representer::JSON::HAL

    property :id
    property :name
    property :industry

    def industry
      legacy_company = CompanyV1.get(id)
      if legacy_company.nil?
        "undescribed"
      else
        CompanyV1.get(id).industry
      end
    end

    collection :ads,
      :class => Ad,
      :extend => V2::AdRepresenter,
      :embedded => true

    link :self do "http://localhost:9292/companies/#{id}/full" end
    link :basic do "http://localhost:9292/companies/#{id}" end
  end


  class CompanyRessource < Grape::API

    resource :companies do

      route_param :id do
        get do
          company = Company.get(params[:id])
          company.extend CompanyRepresenter
          company
        end

        get :full do
          company = Company.get(params[:id])
          company.extend CompanyEmbeddedRepresenter
          company
        end
      end

      params do
        requires :name, type: String, desc: "Ad name"
        requires :industry, type: String, desc: "Industry of the Company"
      end
      post do
        company = Company.create(name: params[:name], credit_card_number: "Not defined yet")
        CompanyV1.create(industry: params[:industry], company_id: company.id)
        company.extend CompanyRepresenter
        company
      end

    end
  end
end
