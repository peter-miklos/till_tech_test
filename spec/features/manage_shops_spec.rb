require "spec_helper"

feature "show shops" do

  let!(:shop1) {Shop.create(name: "The Coffee Shop", address: "London", phone: "12345")}
  let!(:shop2) {Shop.create(name: "Test Shop", address: "Bristol", phone: "54321")}

  scenario "show the available shops" do
    visit "/shops"

    expect(page).to have_content("The Coffee Shop")
    expect(page).to have_content("Test Shop")
  end

  scenario "chosen shop's name is visible in the header" do
    visit "/shops"
    click_link "Test Shop"

    expect(page).to have_css("header", text: "Test Shop")
  end

end
