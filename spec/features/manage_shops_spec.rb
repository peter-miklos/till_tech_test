require "spec_helper"

feature "show products" do

  let!(:shop) {Shop.create(name: "Test Shop", address: "London", phone: "12345")}

  scenario "show the available shops" do
    visit "/shops"
    
    expect(page).to have_content("Test Shop")
  end

end
