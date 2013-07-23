class CompanyRessource < Grape::API

  # because there exists different versions, between v1 and v2 mount them
  version 'v2', using: :accept_version_header
  mount V2::CompanyRessource

  version 'v1', using: :accept_version_header
  mount V1::CompanyRessource


  add_swagger_documentation
end
