require_relative '../data_mapper_setup'

class Order
  include DataMapper::Resource

  property :id,         Serial
  property :content,    Object
  property :total,      Float

  belongs_to  :shop
  has n,      :products, through: :shop

end
