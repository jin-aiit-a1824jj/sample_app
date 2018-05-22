class RelationshipsController < ApplicationController
#リスト 14.32: リレーションシップのアクセス制御
before_action :logged_in_user

  #リスト 14.33: Relationshipsコントローラ
  # POST /relationships
  def create
    #ビューで変数を使うため、userが@userに変わった
    @user = User.find(params[:followed_id])
    current_user.follow(@user)#DB更新
    #redirect_to user
  
    #リスト 14.36: RelationshipsコントローラでAjaxリクエストに対応する
    respond_to do |format|
      format.html { redirect_to @user }
      format.js #明示的な表記がなかったら default（app/views/relationships/create.js.erb）が実行
    end
  end

  # DELETE /relationships/:id
  def destroy
    #ビューで変数を使うため、userが@userに変わった
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    #redirect_to user
  
    #リスト 14.36: RelationshipsコントローラでAjaxリクエストに対応する
    respond_to do |format|
      format.html { redirect_to @user }
      format.js #default（app/views/relationships/destroy.js.erb）が実行
    end
  end

end
