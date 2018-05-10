class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
      # https://bf89b2b37a154dd2a293011968181228.vfs.cloud9.us-east-2.amazonaws.com/account_activations/トークン/edit?email=メールアドレス ＜ー認証メールのリンクの形
      #emailからちゃんと見つけたのか？
      #activatedはまだしてないはず 
      #auth、トークンが正しいのか？
      if user && !user.activated? && user.authenticated?(:activation, params[:id]) 
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