module CompanyEmbeddedRepresenter
  include Roar::Representer::JSON::HAL
#  include CompanyRepresenter # could be used if there wouldn't be a mess with links

  property :id
  property :name
  collection :ads,
    :class => Ad,
    :extend => AdRepresenter,
    :embedded => true


  link :self do "http://localhost:9292/companies/#{id}/full" end
  link :basic do "http://localhost:9292/companies/#{id}" end
end
