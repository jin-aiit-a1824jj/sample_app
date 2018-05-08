class UsersController < ApplicationController

  def show
    # 変数 ーローカル変数変数
    # @変数 ーインスタンス変数
    @user = User.find(params[:id])
    #@user = User.find_by(params[:id])
    # @user => app/views/users/show.html.erb
    # debugger #break point, next step exit 使用しない時は解除！
  end

  def new
    @user = User.new
  end

  def create
    #@user = User.new
    #@user.name  = params[:user][:name]
    #@user.email = params[:user][:email]
    #              params[:user][:password]
    
    #@user = User.new(params[:user]) #params[:user] <- secureではない ここのparamsはユーザーが入力する部分
    
    @user =  User.new(user_params)
    
    if @user.save # => validation
      #success
      
      log_in @user #ユーザー登録中にログインする
      
      flash[:success] = "Welcome to the Sample App!"
      
      redirect_to @user
      # GET "/users/#{@user.id}" => show
      
      # redirect_to user_path(@user)
      # redirect_to user_path(@user.id)
      # redirect_to "/users/#{@user.id}"
    else
      #failures
      render 'new'
    end
    
    
  end


  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
