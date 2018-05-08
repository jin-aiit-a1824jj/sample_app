module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする（復元出来るようになった）
  def remember(user)
    user.remember # -> DB: remember_digest
    cookies.permanent.signed[:user_id] = user.id #user.id を signed関数により暗号化されてクッキーの中に保存
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    #findにした場合、セッションが切れた度にエラーが出ってしまう。だからfind_byを使う
    #find_byを頻繁に使うにはコストが掛かるので性能が落ちる、可能であれば省略出来る方法で
    
    #if @current_user == nil
    #  @current_user = User.find_by(id: session[:user_id])
    #else
    #  @current_user
    #end
    
    #上のif文を１行で圧縮したら。
    # @current_user =  @current_user || User.find_by(id: session[:user_id])
    #@current_user ||= User.find_by(id: session[:user_id])
    
    
    #リスト 9.9: 永続的セッションのcurrent_userを更新する
    
    if (user_id = session[:user_id]) #代入した後、if文判断
      
      @current_user ||= User.find_by(id: user_id)
      
    elsif (user_id = cookies.signed[:user_id])
      
      user = User.find_by(id: user_id)
      
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    
    end
    
    #上のifなどに入らずに終わってしまったら。。。 暗黙も戻り値 -> nil
    
  end


  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil? #関数のcurrent_userです。
    #debugger
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
end
