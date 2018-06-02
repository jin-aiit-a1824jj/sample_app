class PasswordResetsController < ApplicationController
  #リスト 12.15: パスワード再設定のeditアクション
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  #リスト 12.16: パスワード再設定のupdateアクション
  before_action :check_expiration, only: [:edit, :update] #(1) への対応案 パスワード再設定の有効期限が切れていないか
  
  # GET /password_resets/new
  def new
  end

  # POST /password_resets == passeord_resets_path
  # params[:password_reset][:email] <- ユーザー入力
  def create
    
    @user = User.find_by(email: params[:password_reset][:email].downcase) #downcase email address 全部小文字 userの入力に対応
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t 'pw_reset_message' #"Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t 'pw_reset_not_find' #"Email address not found"
      render 'new'
    end
  
  end

  # get / password_resets/:id/edit
  def edit
    # パスワードを入力してもらうフォームを描画
    #@user = User.find_by(email: params[:email])
    #refactoring的に足りうるなのか？
    # def get_userの 存在、位置
  end
  
  # PATCH /password_resets/:id?email=foo@bar.com
  def update

    # パスワードを再設置
    if params[:user][:password].empty?                  # (3) への対応 新しいパスワードが空文字列になっていないか (ユーザー情報の編集ではOKだった)
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)          # (4) への対応 新しいパスワードが正しければ、更新する
      log_in @user
      flash[:success] = I18n.t 'pw_reset_success' #"Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # (2) への対応 無効なパスワードであれば失敗させる (失敗した理由も表示する)
    end
  
  end
  
   #リスト 12.15: パスワード再設定のeditアクション
   private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      if not (@user && @user.activated? && @user.authenticated?(:reset, params[:id])) #userがあり、activateされたか、認証されたか
        redirect_to root_url
      end
    end
  
    # リスト 12.16: パスワード再設定のupdateアクション
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = I18n.t 'pw_reset_expired' #"Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
  
end
