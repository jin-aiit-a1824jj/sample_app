class StaticPagesController < ApplicationController
  def home
    #中身がない場合、デフォルトのアクションが反応
    #app/views/リソース名/アクション名.html.erb
    #app/views/static_pages/home.html.erb
  #リスト 13.40: homeアクションにマイクロポストのインスタンス変数を追加する 
  #@micropost = current_user.microposts.build if logged_in?
  
  #リスト 13.47: homeアクションにフィードのインスタンス変数を追加する
   if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
   end
  
  end

  def help
  end
  
  def about
    #app/views/static_pages/about.html.erb
  end
  
  def contact
    #app/views/static_pages/contact.html.erb
  end
  
end
