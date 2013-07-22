class Server < Grape::API
  format :json

  mount CompanyRessource
  mount AdRessource

  # is broken now
  add_swagger_documentation
end
