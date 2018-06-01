require 'spec_helper'
require 'rails_helper'

describe "session_controller_Test" , :type => :request do
  
  it "should get new" do
    get login_path
    assert_response :success
  end

end