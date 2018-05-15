class MicropostsController < ApplicationController

#リスト 13.34: Micropostsコントローラの各アクションに認可を追加する
  before_action :logged_in_user, only: [:create, :destroy]
#リスト 13.52: Micropostsコントローラのdestroyアクション
  before_action :correct_user,   only: :destroy

  #リスト 13.36: Micropostsコントローラのcreateアクション
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      #リスト 13.50: createアクションに空の@feed_itemsインスタンス変数を追加する
      @feed_items = current_user.feed.paginate(page: params[:page])#[]
      render 'static_pages/home'
    end
  end
  
  #リスト 13.52: Micropostsコントローラのdestroyアクション
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      #params.require(:micropost).permit(:content)
      
      #リスト 13.61: pictureを許可された属性のリストに追加する
      params.require(:micropost).permit(:content, :picture)
      
    end
    
    #リスト 13.52: Micropostsコントローラのdestroyアクション
    # DELETE /microposts/:id
    # ここは抽象化できない。中身が完全違うため
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
      # (top page)              -> DELETE
      # /users/1(profile page)  -> DELETE
    end
end
