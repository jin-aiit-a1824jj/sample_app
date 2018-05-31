require 'spec_helper'
require 'rails_helper'
#require './test/test_helper'

module LoginModule
  
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end
  
end


describe "UsersSignupTest" , :type => :request do

  include LoginModule
  
  before do
    ActionMailer::Base.deliveries.clear
  end

  after(:all) do
   # ActionMailer::Base.deliveries.clear
  end

  it "invalid signup information" do
    get signup_path
    
    beforeCount = User.count
    post users_path, params: { user: { name:  "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar" } }
    afterCount = User.count
    expect(beforeCount).to eq afterCount
    
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end


  #リスト 11.33: ユーザー登録のテストにアカウント有効化を追加する
  it "valid signup information with account activation" do
    
    get signup_path
    
    beforeCount = User.count
    post users_path, params: { user: { name:  "Example User t",
                                         email: "user_t@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    afterCount = User.count
    expect(afterCount - beforeCount).to eq 1
    
  
    assert_equal 1, ActionMailer::Base.deliveries.size
    
    user = assigns(:user)
    expect(user.activated?).to eq false
    
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    expect(is_logged_in? && user.activated?).to eq false
    
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    expect( is_logged_in? ).to eq false
    
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    expect(is_logged_in?).to eq false
    
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    expect(user.reload.activated?).to eq true
    follow_redirect!
    assert_template 'users/show'
    expect(is_logged_in?).to eq true
  end

end

