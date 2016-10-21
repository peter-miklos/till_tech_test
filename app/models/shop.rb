require_relative '../data_mapper_setup'

class Shop
  include DataMapper::Resource

  property :id,         Serial
  property :name,       Text, required: true, length: 100
  property :address,    Text, required: true, length: 200
  property :phone,      String, required: true

  has n, :products

end
