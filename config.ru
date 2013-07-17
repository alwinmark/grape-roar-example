require 'grape'

require 'roar/representer/json'
require 'roar/representer/json/hal'

require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
#require 'dm-serializer'

require './server'
require './ad.rb'
require './ad_representer.rb'
require './ad_collection_representer.rb'

require "./company.rb"
require "./company_representer.rb"
require "./company_embedded_representer.rb"

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite:///tmp/ad.db")
DataMapper.auto_upgrade!



run Server
