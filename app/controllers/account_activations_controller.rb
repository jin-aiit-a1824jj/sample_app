class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
      #emailからちゃんと見つけたのか？
      if user &&
        !user.activated? && #activatedはまだしてないはず 
        user.authenticated?(:activation, params[:id]) #auth、トークンが正しいのか？
        
        user.activate #リスト 11.37: ユーザーモデルオブジェクト経由でアカウントを有効化する
        #user.update_attribute(:activated,    true)
        #user.update_attribute(:activated_at, Time.zone.now)
        
        log_in user
        flash[:success] = "Account activated!"
        redirect_to user 
    
      else
    
        flash[:danger] = "Invalid activation link"
        redirect_to root_url
      end
  end
  
  
end