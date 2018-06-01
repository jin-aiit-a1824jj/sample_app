require 'spec_helper'
require 'rails_helper'

describe "static_pages_controller_Test" , :type => :request do
  
  it "should get home" do
    get root_path #get static_pages_home_url
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end

  it "should get help" do
    get help_path # get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  it "should get about" do
    get about_path #get static_pages_about_url
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end

  it "should get contact" do
    get contact_path #get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
  end
 
end