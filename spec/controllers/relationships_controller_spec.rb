require 'spec_helper'
require 'rails_helper'

describe "relationships_controller_Test" , :type => :request do
 
  #リスト 14.31: リレーションシップの基本的なアクセス制御に対するテスト
  it "create should require logged-in user" do
    before_Relationship_count = Relationship.count
    post relationships_path
    after_Relationship_count = Relationship.count
    expect(before_Relationship_count).to eq after_Relationship_count
    assert_redirected_to login_url
  end

  it "destroy should require logged-in user" do
    before_Relationship_count = Relationship.count
    post relationships_path(:one)
    after_Relationship_count = Relationship.count
    expect(before_Relationship_count).to eq after_Relationship_count
    assert_redirected_to login_url
  end

end