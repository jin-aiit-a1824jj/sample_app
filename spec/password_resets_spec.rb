require 'spec_helper'
require 'rails_helper'
require 'login_helper'

describe "password_resets_Test" , :type => :request do
  
  include LoginModule
  
  before do
    ActionMailer::Base.deliveries.clear
    @user = create(:michael)
  end
  
  it "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    
    # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }
    expect(flash.empty?).to eq false
    assert_template 'password_resets/new'
    
    # メールアドレスが有効
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
         
    expect(@user.reset_digest).not_to eq @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    expect(flash.empty?).to eq false
    assert_redirected_to root_url
    
    # パスワード再設定フォームのテスト
    user = assigns(:user)
    
    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    
    # 無効なユーザー
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    
    # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    
    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    
    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    expect(flash.empty?).to eq false
    assert_redirected_to user
  end

end