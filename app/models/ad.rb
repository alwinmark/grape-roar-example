class Ad
  include DataMapper::Resource

  belongs_to :company

  property :id, Serial
  property :name, String
  property :image_url, String
  property :company_id, Integer

end
