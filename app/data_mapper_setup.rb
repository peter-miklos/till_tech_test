require 'data_mapper'
require 'dm-postgres-adapter'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/till_#{ENV['RACK_ENV']}")
DataMapper::Logger.new($stdout, :debug)
DataMapper.finalize
DataMapper.auto_upgrade!
