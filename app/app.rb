require 'sinatra/base'
require 'sinatra/flash'
require 'json'
require_relative 'data_mapper_setup'
require_relative "helpers"

ENV["RACK_ENV"] ||= "development"

class TillApp < Sinatra::Base
  register Sinatra::Flash
  enable :sessions
  set :session_secret, "super secret"
  helpers Helpers

  get '/' do
    redirect '/orders'
  end

  get '/orders' do
    erb :'orders/index'
  end

  get '/shops' do
    @shops = Shop.all
    erb :"shops/index"
  end

  get "/shops/?:id?" do
    if (params[:id] == nil)
      flash[:errors] = ["Please choose a shop first"]
      redirect "/shops"
    end
    session[:shop_id] = params[:id]
    @shop = Shop.get(params[:id])
    @products = Product.all(shop_id: @shop.id)
    erb :"shops/show"
  end

  post "/shops/?:id?/order" do

    total = 0
    content = []
    params.each do |k, v|
      if (v == "on")
        id = k.to_i
        product = Product.get(id)
        @shop = Shop.get(product.shop_id)
        quantity = params["quantity_#{id}".to_sym].to_i
        sum = (product.price * quantity).round(2)
        content << {product: product, sum: sum}
        total += sum
      end
    end
    Order.create(total: total, content: content, shop_id: @shop.id)
    redirect "/shops"
  end

  get '/shops/products/new' do
    erb :"shops/products/new"
  end

  post '/shops/products' do
    manage_uploaded_file
    create_shop_products
    redirect "/shops/#{@shop.id}"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
