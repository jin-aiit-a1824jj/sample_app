require 'spec_helper'
require 'rails_helper'
require './test/test_helper'
require 'login_helper'

describe "Users_Login_Test" , :type => :request do

  include ApplicationHelper
  include LoginModule
  
  before do
    @user = create(:michael)
  end

  #login false case
  it "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    expect(flash.empty?).to eq false
    get root_path
    assert flash.empty?
  end

  #login success case
  it "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
  
  it "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    expect(is_logged_in?).to eq false
    assert_redirected_to root_url
    
    #リスト 9.14: ユーザーログアウトのテスト
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  #リスト 9.25: [remember me] チェックボックスのテスト
  it "login with remembering" do
    log_in_as(@user, remember_me: '1')
    expect(cookies['remember_token'].empty?).to eq false;
  end

  it "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end


end

