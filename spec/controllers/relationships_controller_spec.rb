require 'spec_helper'
require 'rails_helper'

describe "relationships_controller_Test" , :type => :request do
 
  #リスト 14.31: リレーションシップの基本的なアクセス制御に対するテスト
  it "create should require logged-in user" do
    expect{
      post relationships_path
    }.to_not change{Relationship.count}
    assert_redirected_to login_url
  end

  it "destroy should require logged-in user" do
    expect{
      post relationships_path(:one)
    }.to_not change{Relationship.count}
    assert_redirected_to login_url
  end

end