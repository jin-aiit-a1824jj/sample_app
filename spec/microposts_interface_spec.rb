require 'spec_helper'
require 'rails_helper'
require 'login_helper'

describe "micropost_interface_Test" , :type => :request do
  
  include LoginModule
  
  before do
    @user = create(:michael)
    @another_user = create(:archer);
  end
  
  it "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    
    # 無効な送信
    before_Micropost_count = Micropost.count
    post microposts_path, params: { micropost: { content: "" } }
    after_Micropost_count = Micropost.count
    expect(before_Micropost_count).to eq after_Micropost_count
    assert_select 'div#error_explanation'
    
    # 有効な送信
    content = "This micropost really ties the room together"
    before_Micropost_count = Micropost.count
    post microposts_path, params: { micropost: { content: content } }
    after_Micropost_count = Micropost.count
    expect(after_Micropost_count - before_Micropost_count).to eq 1
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    
    before_Micropost_count = Micropost.count
    delete micropost_path(first_micropost)
    after_Micropost_count = Micropost.count
    expect(before_Micropost_count - after_Micropost_count ).to eq 1
    
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(@another_user)
    assert_select 'a', text: 'delete', count: 0
  end
  

end