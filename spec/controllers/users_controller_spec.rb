require 'spec_helper'
require 'rails_helper'
require 'login_helper'

describe "User_controller_Test" , :type => :request do
  
  include LoginModule
  
  before do
    @user = create(:michael)
    @other_user = create(:archer);
  end
  
  #リスト 10.34: indexアクションのリダイレクトをテストする
  it "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  it "should get new" do
    get signup_path
    assert_response :success
  end

  #リスト 10.20: editとupdateアクションの保護に対するテストする
  it "should redirect edit when not logged in" do
    get edit_user_path(@user)
    expect(flash.empty?).to eq false
    assert_redirected_to login_url
  end

  it "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    expect(flash.empty?).to eq false
    assert_redirected_to login_url
  end


  #リスト 10.24: 間違ったユーザーが編集しようとしたときのテスト
  it "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    expect(flash.empty?).to eq true
    assert_redirected_to root_url
  end

  it "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    expect(flash.empty?).to eq true
    assert_redirected_to root_url
  end

  it "should redirect destroy when not logged in" do
    expect{
      delete user_path(@user)
    }.to_not change{User.count}
    assert_redirected_to login_url
  end

  it "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    expect{
      delete user_path(@user)
    }.to_not change{User.count}
    assert_redirected_to root_url
  end

  #リスト 14.24: フォロー/フォロワーページの認可をテストする
  it "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  it "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
  
  

end