require 'spec_helper'

feature "add products" do

  scenario "create the shop and add its products" do
    visit "/shops/products/new"
    attach_file('file', File.absolute_path('./app/public/input/hipstercoffee.json'))
    click_button "Upload"

    expect(page).to have_content("The Coffee Connection")
    expect(current_path).to eq "/shops/products"
  end

end
