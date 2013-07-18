module V1
  class API < Grape::API

    mount V2::AdRessource
    mount CompanyRessource
  end
end
