require "spec_helper"

feature "add new order" do
  let!(:shop1) {Shop.create(name: "The Coffee Connection", address: "London", phone: "12345")}
  let!(:product1) {Product.create(name: "Cafe Latte", price: 1.99, shop_id: shop1.id)}
  let!(:product2) {Product.create(name: "Flat White", price: 1.89, shop_id: shop1.id)}
  let!(:product3) {Product.create(name: "Tiramisu", price: 3.99, shop_id: shop1.id)}

  it "creates the order with the chosen products" do
    visit "/shops"
    click_link "The Coffee Connection"
    find(:css, "#ch_#{product1.id}").set(true)
    fill_in("quantity_#{product1.id}", with: 3)
    find(:css, "#ch_#{product2.id}").set(true)
    fill_in("quantity_#{product2.id}", with: 2)
    within("div#submit_1") {click_button("Submit order")}

    expect(page).to have_content("Cafe Latte")
    expect(page).to have_content("Flat White")
    expect(page).not_to have_content("Tiramisu")

    expect(page).to have_content("9.75")
  end

end
