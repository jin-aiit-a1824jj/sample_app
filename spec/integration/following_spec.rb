require 'spec_helper'
require 'rails_helper'
require 'login_helper'

describe "following_Test" , :type => :request do
  
  include LoginModule
  
  before do
    @user = michal = create(:michael)
    @other = archer = create(:archer);
    lana = create(:lana)
  
    #fatoriesでは上手く行かず
    #とりあえず、relationship 作成
    log_in_as(michal)
    post relationships_path, params: { followed_id: lana.id }

    log_in_as(lana)
    post relationships_path, params: { followed_id: michal.id }
    
    log_in_as(archer)
    post relationships_path, params: { followed_id: michal.id }
    
    log_in_as(@user)
  end
  
  it "following page" do
    get following_user_path(@user)
    expect(@user.following.empty?).to eq false
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  it "followers page" do
    get followers_user_path(@user)
    expect(@user.followers.empty?).to eq false
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  #リスト 14.40: [Follow] / [Unfollow] ボタンをテストする 
  it "should follow a user the standard way" do
    before_following_count = @user.following.count
    post relationships_path, params: { followed_id: @other.id }
    after_following_count = @user.following.count
    expect(after_following_count - before_following_count).to eq 1
  end

  #xhr: true <- Ajaxを確認するためのフラグ
  it "should follow a user with Ajax" do
    before_following_count = @user.following.count
    post relationships_path, xhr: true, params: { followed_id: @other.id }
    after_following_count = @user.following.count
    expect(after_following_count - before_following_count).to eq 1
  end

  it "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    
    before_following_count = @user.following.count
    delete relationship_path(relationship)
    after_following_count = @user.following.count
    expect(after_following_count - before_following_count).to eq -1
  end
  
  #xhr: true <- Ajaxを確認するためのフラグ
  it "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    
    before_following_count = @user.following.count
    delete relationship_path(relationship), xhr: true
    after_following_count = @user.following.count
    expect(after_following_count - before_following_count).to eq -1
  end
  

end