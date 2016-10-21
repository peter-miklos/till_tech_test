require_relative '../data_mapper_setup'

class Product
  include DataMapper::Resource

  property :id,         Serial
  property :name,       Text, required: true, length: 100
  property :price,      Float, required: true

  belongs_to :shop

end
