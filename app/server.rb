class Server < Grape::API
  format :json

# it could also be a good idea to version the resources itself
  version 'v2', using: :accept_version_header
#  version 'v2', using: :header, vendor: 'adcloud'
#  version 'v2', using: :path
#  version 'v2', using: :param
  mount V2::API
  get do
    "Hello V2"
  end

  version 'v1', using: :accept_version_header
#  version 'v1', using: :header, vendor: 'adcloud'
#  version 'v1', using: :path
#  version 'v1', using: :param
  mount V1::API
  get do
    "Hello V1"
  end

  add_swagger_documentation
end
