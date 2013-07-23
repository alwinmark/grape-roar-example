class Server < Grape::API
  format :json

  mount CompanyRessource
  mount AdRessource

  # swagger seems to not support mounting, so it has to be added to every resource
  # add_swagger_documentation
end
