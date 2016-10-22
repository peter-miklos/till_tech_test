require "spec_helper"

feature "show products" do

  let!(:shop1) {Shop.create(name: "The Coffee Shop", address: "London", phone: "12345")}
  let!(:shop2) {Shop.create(name: "Test Shop", address: "Bristol", phone: "54321")}

  scenario "show the available shops" do
    visit "/shops"

    expect(page).to have_content("The Coffee Shop")
    expect(page).to have_content("Test Shop")
  end

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

  scenario "chosen shop's name is visible in the header" do
    visit "/shops"
    click_link "Test Shop"

    expect(page).to have_css("header", "Test Shoppp")
  end

end
