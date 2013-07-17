require "rubygems"
require "bundler/setup"
Bundler.require

require_all 'app/**/*.rb'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite:///tmp/ad.db")
DataMapper.auto_upgrade!


run Server
