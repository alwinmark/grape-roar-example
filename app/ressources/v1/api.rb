module V1
  class API < Grape::API

    mount AdRessource
    mount CompanyRessource
  end
end
