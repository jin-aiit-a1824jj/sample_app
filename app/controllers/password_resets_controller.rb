class PasswordResetsController < ApplicationController
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
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  
  end

  # get / password_resets/:id/edit
  def edit
  end
  
  # PATCH /password_resets/:id
  def update
  end
  
end
