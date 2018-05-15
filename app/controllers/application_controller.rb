class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper #ApplicationControllerを継承していれば、インクルード。。。
  
  def hello
    render html: "hello, world!"
  end
  
  #リスト 13.32: logged_in_userメソッドをApplicationコントローラに移す
  private
  
  # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        # GET /users/:id/edit 今回の想定ではこれだけ
        # PATCH /users/:id いらない
        # => GET /users/:id
        store_location #リスト 10.31: ログインユーザー用beforeフィルターにstore_locationを追加する
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
end
