require 'spec_helper'
require 'rails_helper'

describe 'micropost_models' do

  before do
   @user = create(:michael)
   @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  it "should be valid" do
    expect(@micropost.valid?).to eq true
  end

  it "user id should be present" do
    @micropost.user_id = nil
    expect(@micropost.valid?).to eq false
  end
  
  #リスト 13.7: Micropostモデルのバリデーションに対するテスト
  
  it "content should be present" do
    @micropost.content = "   "
    expect(@micropost.valid?).to eq false;
  end

  it "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    expect(@micropost.valid?).to eq false;
  end
  
  #リスト 13.14: マイクロポストの順序付けをテストする
  it "order should be most recent first" do
    #assert_equal create(:most_recent), Micropost.first
    expect(create(:most_recent)).to eq Micropost.first
  end

  
end
