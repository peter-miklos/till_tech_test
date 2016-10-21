require 'data_mapper'
require 'dm-postgres-adapter'

require_relative './models/shop.rb'
require_relative './models/product.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/till_#{ENV['RACK_ENV']}")
DataMapper::Logger.new($stdout, :debug)
DataMapper.finalize
DataMapper.auto_upgrade!
