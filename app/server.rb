class Server < Grape::API
  format :json

  resource :test do
    get do
      {data: "Hello"}
    end
  end

  resource :ads do

    get do
      ads = Ad.all
      ads.extend AdCollectionRepresenter
      ads
    end

    route_param :id do
      get do
        ad = Ad.get(params[:id])
        ad.extend AdRepresenter
        ad
      end
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
      company.extend CompanyRepresenter
      company
    end

  end

  add_swagger_documentation
end
