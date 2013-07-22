module V2

  module CompanyRepresenter
    include Roar::Representer::JSON::HAL

    property :id
    property :name
    property :credit_card_number

    link :self do "http://localhost:9292/companies/#{id}/basic" end
    link :full do "http://localhost:9292/companies/#{id}" end
  end

  module CompanyEmbeddedRepresenter
    include Roar::Representer::JSON::HAL

    property :id
    property :name
    property :credit_card_number
    collection :ads,
      :class => Ad,
      :extend => V1::AdRepresenter,
      :embedded => true

    link :self do "http://localhost:9292/companies/#{id}" end
    link :basic do "http://localhost:9292/companies/#{id}/basic" end
  end


  class CompanyRessource < Grape::API

    resource :companies do

      route_param :id do
        get do
          company = Company.get(params[:id])
          company.extend CompanyEmbeddedRepresenter
          company
        end

        get :basic do
          company = Company.get(params[:id])
          company.extend CompanyRepresenter
          company
        end
      end

      params do
        requires :name, type: String, desc:"Ad name"
        requires :credit_card_number, type: String, desc:"Creditcard Number for Billing Information"
      end
      post do
        company = Company.create(name: params[:name], credit_card_number: params[:credit_card_number])
        company.extend CompanyRepresenter
        company
      end

    end
  end
end
