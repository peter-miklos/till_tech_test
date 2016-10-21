require 'spec_helper'

feature "add products" do

  scenario "try to upload a file with products w/o choosing a file" do
    visit "/shops/products/new"
    click_button "Upload"

    expect(page).to have_css("ul#errors", "Choose a file first")
    expect(current_path).to eq "/shops/products/new"
  end

  scenario "create the shop and add its products" do
    visit "/shops/products/new"
    attach_file('file', File.absolute_path('./app/public/input/hipstercoffee.json'))
    click_button "Upload"

    expect(page).to have_content("The Coffee Connection")
    expect(current_path).to eq "/shops/products"
  end

end
