class Company
  include DataMapper::Resource

  has n, :ads

  property :id, Serial
  property :name, String
  property :credit_card_number, String

end
