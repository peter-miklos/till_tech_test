require "spec_helper"

feature "add new order" do
  let!(:shop1) {Shop.create(name: "The Coffee Connection", address: "London", phone: "12345")}
  let!(:shop2) {Shop.create(name: "Test Shop", address: "Bristol", phone: "54321")}
  let!(:product1) {Product.create(name: "Cafe Latte", price: 1.99, shop_id: shop1.id)}
  let!(:product2) {Product.create(name: "Flat White", price: 1.89, shop_id: shop1.id)}
  
  it "creates the order with the chosen products" do
    visit "/shops"
    click_link "The Coffee Connection"
    find(:css, "#ch_#{product1.id}").set(true)
    fill_in("quantity_#{product1.id}", with: 3)
    find(:css, "#ch_#{product2.id}").set(true)
    fill_in("quantity_#{product2.id}", with: 2)
    within("div#submit_1") {click_button("Submit order")}

    order = Order.last

    expect(current_path).to eq("/shops/#{shop1.id}/orders/#{order.id}/show")
    expect(page).to have_content("9.75")
    expect(page).to have_content("1.99")
    expect(page).to have_content("1.89")
    expect(page).not_to have_content("3.99")
  end

  it "does not create an order if no product was chosen" do
    visit "/shops"
    click_link "The Coffee Connection"
    within("div#submit_1") {click_button("Submit order")}

    expect(current_path).to eq "/shops/#{shop1.id}"
    expect(page).to have_css("ul#errors", "Please choose product and add quantity")
  end
end

feature "show the lists of orders" do

  let!(:shop1) {Shop.create(name: "The Coffee Connection", address: "London", phone: "12345")}
  let!(:shop2) {Shop.create(name: "Test Shop", address: "Bristol", phone: "54321")}
  let!(:product1) {Product.create(name: "Cafe Latte", price: 1.99, shop_id: shop1.id)}
  let!(:product2) {Product.create(name: "Flat White", price: 1.89, shop_id: shop1.id)}

  scenario "does not show the 'orders' link if no shop was chosen" do
    visit "/shops"
    expect(page).not_to have_css("div#menu", text: "Orders")
  end

  scenario "informs user if there is no order found" do
    visit "/shops"
    click_link "Test Shop"
    click_link "Orders"

    expect(current_path).to eq "/shops/#{shop2.id}/orders"
    expect(page).to have_css("div#yield", text: "No order found")
  end

  scenario "shows the list of existing orders" do
    visit "/shops"
    within("div#yield") {click_link "The Coffee Connection"}
    find(:css, "#ch_#{product1.id}").set(true)
    fill_in("quantity_#{product1.id}", with: 3)
    find(:css, "#ch_#{product2.id}").set(true)
    fill_in("quantity_#{product2.id}", with: 2)
    within("div#submit_1") {click_button("Submit order")}

    visit "/shops"
    within("div#yield") {click_link "The Coffee Connection"}
    find(:css, "#ch_#{product1.id}").set(true)
    fill_in("quantity_#{product1.id}", with: 2)
    find(:css, "#ch_#{product2.id}").set(true)
    fill_in("quantity_#{product2.id}", with: 3)
    within("div#submit_1") {click_button("Submit order")}

    click_link "Orders"
    order1_cr_date_time = (Order.first).created_at.strftime("%d/%m/%Y %H:%M")
    order2_cr_date_time = (Order.last).created_at.strftime("%d/%m/%Y %H:%M")

    expect(current_path).to eq "/shops/#{shop1.id}/orders"
    expect(page).not_to have_css("div#yield", text: "No order found")
    expect(page).to have_css("tr#order", text: order1_cr_date_time)
    expect(page).to have_css("tr#order", text: order2_cr_date_time)
    expect(page).to have_css("tr#order", text: "$9.75")
    expect(page).to have_css("tr#order", text: "$9.65")
  end
end

feature "show order details" do

  let!(:shop1) {Shop.create(name: "The Coffee Connection", address: "London", phone: "12345")}
  let!(:product1) {Product.create(name: "Cafe Latte", price: 1.99, shop_id: shop1.id)}
  let!(:product2) {Product.create(name: "Flat White", price: 1.89, shop_id: shop1.id)}

  scenario "show the content of an existing order" do
    visit "/shops"
    within("div#yield") {click_link "The Coffee Connection"}
    find(:css, "#ch_#{product1.id}").set(true)
    fill_in("quantity_#{product1.id}", with: 3)
    find(:css, "#ch_#{product2.id}").set(true)
    fill_in("quantity_#{product2.id}", with: 2)
    within("div#submit_1") {click_button("Submit order")}

    click_link "Orders"
    within("tr#order") {click_link}
    order = Order.last

    expect(current_path).to eq "/shops/#{shop1.id}/orders/#{order.id}/show"
    expect(page).to have_css("div#yield", text: shop1.name)
    expect(page).to have_css("tr#product", text: product1.price)
    expect(page).to have_css("tr#product", text: product2.price)
  end

end
