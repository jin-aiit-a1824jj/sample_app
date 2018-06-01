require 'spec_helper'
require 'rails_helper'
require 'login_helper'

describe "microposts_controller_Test" , :type => :request do
 
  include LoginModule
 
  #リスト 13.31: Micropostsコントローラの認可テスト
  before do
    @micropost = create(:orange)
  end

  it "should redirect create when not logged in" do
    before_Micropost_count = Micropost.count
    post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    after_Micropost_count = Micropost.count
    expect(before_Micropost_count).to eq after_Micropost_count
    assert_redirected_to login_url
  end

  it "should redirect destroy when not logged in" do
    before_Micropost_count = Micropost.count
    delete micropost_path(@micropost)
    after_Micropost_count = Micropost.count
    expect(before_Micropost_count).to eq after_Micropost_count
    assert_redirected_to login_url
  end
  
  #リスト 13.54: 間違ったユーザーによるマイクロポスト削除に対してテストする
  it "should redirect destroy for wrong micropost" do
    log_in_as(User.first)
    micropost = create(:ants)
    before_Micropost_count = Micropost.count
    delete micropost_path(micropost)
    after_Micropost_count = Micropost.count
    expect(before_Micropost_count).to eq after_Micropost_count
    assert_redirected_to root_url
  end

end