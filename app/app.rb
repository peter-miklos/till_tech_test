require 'sinatra/base'
require 'sinatra/flash'
require 'json'
require_relative 'data_mapper_setup'

ENV["RACK_ENV"] ||= "development"

class TillApp < Sinatra::Base
  register Sinatra::Flash
  enable :sessions
  set :session_secret, "super secret"


  get '/' do
    redirect '/orders'
  end

  get '/orders' do
    erb :'orders/index'
  end

  get '/shops/products/new' do
    erb :"shops/products/new"
  end

  post '/shops/products' do
    if (params[:file] = "")
      flash[:errors] = ["Choose a file first"]
      redirect '/shops/products/new'
    end
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]
    File.open("./app/public/uploads/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    file = File.read("./app/public/uploads/#{@filename}")
    input = JSON.parse(file)

    shop = Shop.first(name: input[0]["shopName"])
    if (!shop)
      shop = Shop.create(name: input[0]["shopName"], address: input[0]["address"],
                      phone: input[0]["phone"])
    end

    input[0]["prices"][0].each do |k, v|
      product = Product.first(name: k, shop_id: shop.id)
      if (product)
        product.update(price: v)
      else
        Product.create(name: k, price: v, shop_id: shop.id)
      end
    end

    redirect "/"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
