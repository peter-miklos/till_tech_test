module Helpers

  DEFAULT_VAT = 10

  def manage_uploaded_file
    validate_file_upload
    save_uploaded_file
    create_json_object
  end

  def validate_file_upload
    if (params[:file] == nil)
      flash[:errors] = ["Choose a file first"]
      redirect '/shops/products/new'
    end
  end

  def save_uploaded_file
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]
    File.open("./app/public/uploads/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
  end

  def create_json_object
    file = File.read("./app/public/uploads/#{@filename}")
    @input = JSON.parse(file)
  end

  def create_shop_products
    find_or_add_shop
    create_proudcts
  end

  def find_or_add_shop
    @shop = Shop.first(name: @input[0]["shopName"])
    if (!@shop)
      @shop = Shop.create(name: @input[0]["shopName"], address: @input[0]["address"],
                          phone: @input[0]["phone"])
    end
  end

  def create_proudcts
    @input[0]["prices"][0].each do |k, v|
      product = Product.first(name: k, shop_id: @shop.id)
      if (product)
        product.update(price: v)
      else
        Product.create(name: k, price: v, shop_id: @shop.id)
      end
    end
  end

end
