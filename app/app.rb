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

  get '/shops/products/new' do
    erb :"shops/products/new"
  end

  post '/shops/products' do
    manage_uploaded_file
    create_shop_products
    redirect "/"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
