module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
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
    @current_user ||= User.find_by(id: session[:user_id])
  end


  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil? #関数のcurrent_userです。
    #debugger
  end

end
