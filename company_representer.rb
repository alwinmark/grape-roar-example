module CompanyRepresenter
  include Roar::Representer::JSON::HAL

  property :id
  property :name

  link :self do "http://localhost:9292/companies/#{id}" end
  link :full do "http://localhost:9292/companies/#{id}/full" end
end
