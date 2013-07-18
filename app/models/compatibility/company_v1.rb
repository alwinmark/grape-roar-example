class CompanyV1
  include DataMapper::Resource

  property :company_id, Integer, key: true
  # is in v2 not avaible anymore, because the models should be up to date
  # we have to store legacy attributes in another model decorating the new one
  property :industry, String
end
