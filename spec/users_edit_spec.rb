require 'spec_helper'
require 'rails_helper'
require 'login_helper'

describe "Users_edit_Test" , :type => :request do

  include LoginModule
  
  before do
    @user = create(:michael)
  end

  it "unsuccessful edit" do
    log_in_as(@user)#リスト 10.17: テストユーザーでログインする 
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
  
   #リスト 10.29: フレンドリーフォワーディングのテスト
  it "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    expect(flash.empty?).to eq false
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end