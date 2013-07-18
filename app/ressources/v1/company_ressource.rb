module V1

  module CompanyRepresenter
    include Roar::Representer::JSON::HAL

    property :id
    property :name
    property :industry

    def industry
      "bla"
    end

    link :self do "http://localhost:9292/companies/#{id}" end
    link :full do "http://localhost:9292/companies/#{id}/full" end
  end

  module CompanyEmbeddedRepresenter
    include Roar::Representer::JSON::HAL

    property :id
    property :name
    collection :ads,
      :class => Ad,
      :extend => AdRepresenter,
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
        requires :name, type: String, desc:"Ad name"
      end
      post do
        company = Company.create(name: params[:name])
        old_company = CompanyV1.create(legacy_property: params[:legacy_property], company_id: old_company.id)
        company.extend CompanyRepresenter
        company
      end

    end
  end
end
