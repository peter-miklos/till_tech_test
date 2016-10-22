require_relative '../data_mapper_setup'

class Order
  include DataMapper::Resource

  property :id,         Serial
  property :content,    Object, required: true
  property :total,      Float, required: true
  property :created_at, DateTime
  property :created_on, Date
  property :updated_at, DateTime
  property :updated_on, Date

  belongs_to  :shop
  has n,      :products, through: :shop

end
