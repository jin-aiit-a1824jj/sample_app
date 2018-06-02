class SessionsController < ApplicationController

  def new
    #@session = Session.new  modelがないので不可
  end


  #POST /login => create action
  def create
    user = User.find_by(email: params[:session][:email].downcase) 
    #find_by 見つからない場合=＞nill
    #nil objectでは、authenticateメッソドが定義されているわけがない メッソドが定義されてないエラーがでる。
    #nil -> false
    if user && user.authenticate(params[:session][:password]) #User object or false
      
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      #log_in user
     
      #remember => save to DB + cookies[:token]
      #remember user #SessionsHelper method
      
      #リスト 9.23: [remember me] チェックボックスの送信結果を処理する
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user) #remember_meのデフォルト値はINTではなく文字！
      
      #redirect_to user
      #redirect_back_or user #リスト 10.32: フレンドリーフォワーディングを備えたcreateアクション
    
      #リスト 11.32: 有効でないユーザーがログインすることのないようにする
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        #message  = "Account not activated. "
        #message += "Check your email for the activation link."
        flash[:warning] = I18n.t 'session_combination_not_activate' #message
        redirect_to root_url
      end

    else
      # エラーメッセージを作成する
      #flash[:danger] = 'Invaild email/password combination'
      #flash 次のリクエストがくるまで生きている flash.nowを使う
      flash.now[:danger] = I18n.t 'session_combination_fail' #'Invaild email/password combination'
      render 'new'
    end
  end
  
  #DELETE /logout
  def destroy
    log_out if logged_in? #リスト 9.16: ログイン中の場合のみログアウトする
    redirect_to root_url
  end


end
