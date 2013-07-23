class AdRessource < Grape::API

  # Ad Ressource didn't change so v1 can be used for v2 too
  version ['v1', 'v2'], using: :accept_version_header
  mount V1::AdRessource

  # and here it seems to break, because it can't handle multiple versions
  # add_swagger_documentation
end
