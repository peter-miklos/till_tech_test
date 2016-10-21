require 'sinatra/base'
require 'json'
require_relative 'data_mapper_setup'

ENV["RACK_ENV"] ||= "development"

class TillApp < Sinatra::Base
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
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]
    File.open("./app/public/uploads/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    file = File.read("./app/public/uploads/#{@filename}")
    data_hash = JSON.parse(file)
    redirect "/"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
