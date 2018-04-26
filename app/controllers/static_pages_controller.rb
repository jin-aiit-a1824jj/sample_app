class StaticPagesController < ApplicationController
  def home
    #中身がない場合、デフォルトのアクションが反応
    #app/views/リソース名/アクション名.html.erb
    #app/views/static_pages/home.html.erb
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
