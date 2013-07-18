require "rubygems"
require "bundler/setup"
Bundler.require

require_all 'app/**/*.rb'

DataMapper::Logger.new($stdout, :debug)
if ENV['RACK_ENV'] == "test"
  DataMapper.setup(:default, "sqlite:///tmp/ad_test.db")
else
  DataMapper.setup(:default, "sqlite:///tmp/ad.db")
end
DataMapper.auto_upgrade!


run Server
