require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  #リスト 13.4: 新しいMicropostの有効性に対するテスト
  
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない, 新しく作る→バグの余地がある！
    #@micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    
    #慣習的に正しい
    @micropost = @user.microposts.build(content: "Lorem ipsum")
    #current_user.microposts.build(content: ....)
    # .... <- params[:user_id].require(:micropost).permit(:content)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  #リスト 13.7: Micropostモデルのバリデーションに対するテスト
  
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  #リスト 13.14: マイクロポストの順序付けをテストする
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
end
