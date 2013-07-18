require "rubygems"
require "bundler/setup"
Bundler.require

require_all 'app/**/*.rb'

DataMapper::Logger.new($stdout, :debug)
if ENV['RACK_ENV'] == "test"
  DataMapper.setup(:default, "sqlite:///tmp/ad_test.db")
  use Rack::Logger, Logger.new('log/test.log', :debug)
else
  DataMapper.setup(:default, "sqlite:///tmp/ad.db")
  use Rack::Logger, Logger.new('log/app.log', :debug)
end
DataMapper.auto_upgrade!


run Server
