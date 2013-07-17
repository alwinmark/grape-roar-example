class Company
  include DataMapper::Resource

  has n, :ads

  property :id, Serial
  property :name, String

end
