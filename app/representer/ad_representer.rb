module AdRepresenter
  include Roar::Representer::JSON::HAL

  property :id
  property :name
  property :image_url

  link :self do "http://localhost:9292/ads/#{id}" end
  link :all do "http://localhost:9292/ads" end
  link :company do "http://localhost:9292/companies/#{company_id}" end

end
