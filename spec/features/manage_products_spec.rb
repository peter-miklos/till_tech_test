require 'spec_helper'

feature "add products" do

  scenario "try to upload a file with products w/o choosing a file" do
    visit "/shops/products/new"
    click_button "Upload"

    expect(page).to have_css("ul#errors", "Choose a file first")
    expect(current_path).to eq "/shops/products/new"
  end

  scenario "by uploading json file create the shop if the shop didn't exist" do
    visit "/shops/products/new"
    attach_file('file', File.absolute_path('./app/public/input/hipstercoffee.json'))
    click_button "Upload"

    shop = Shop.first(name: "The Coffee Connection")

    expect(page).to have_content("The Coffee Connection")
    expect(current_path).to eq "/shops/#{shop.id}"
  end

  scenario "uploads the products" do
    visit "/shops/products/new"
    attach_file('file', File.absolute_path('./app/public/input/hipstercoffee.json'))
    click_button "Upload"

    first_product = Product.first
    last_product = Product.last

    expect(page).to have_content(first_product.name)
    expect(page).to have_content(last_product.name)
  end
end

feature "show products" do

  let!(:shop1) {Shop.create(name: "The Coffee Shop", address: "London", phone: "12345")}
  let!(:shop2) {Shop.create(name: "Test Shop", address: "Bristol", phone: "54321")}

  scenario "user is informed if there is no product at a shop" do
    visit "/shops"
    click_link("Test")

    expect(page).to have_content("No products found")
  end

  scenario "uploaded products are visible in products site" do
    visit "/shops/products/new"
    attach_file('file', File.absolute_path('./app/public/input/hipstercoffee.json'))
    click_button "Upload"

    visit "/shops"
    within("main") {click_link "The Coffee Connection"}

    expect(page).to have_content("Cortado")
    expect(page).to have_content("Double Espresso")
  end

end
