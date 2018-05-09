class UsersController < ApplicationController
  #リスト 10.15: beforeフィルターにlogged_in_userを追加する #リスト 10.19: セキュリティモデルを確認するためにbeforeフィルターをコメントアウトする
  before_action :logged_in_user, only: [:index, :edit, :update]#リスト 10.35: indexアクションにはログインを要求する
  #リスト 10.25: beforeフィルターを使って編集/更新ページを保護する
  before_action :correct_user,   only: [:edit, :update]
  
  #リスト 10.36: ユーザーのindexアクション
  def index
    #@users = User.all
    #リスト 10.46: indexアクションでUsersをページネートする
    @users = User.paginate(page: params[:page])
  end
  
  def show
    # 変数 ーローカル変数変数
    # @変数 ーインスタンス変数
    @user = User.find(params[:id])
    #@user = User.find_by(params[:id])
    # @user => app/views/users/show.html.erb
    # debugger #break point, next step exit 使用しない時は解除！
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
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

  # GET /users/:id/edit
  # params[:id] -> :id
  def edit
    @user = User.find(params[:id])
    # -> app/views/users/edit.html.erb
  end
  
  #PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #success
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      #false
      # -> @user.errors.full_messages()
      render 'edit'
    end
  end
  

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


    # beforeアクション

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
    
    # 正しいユーザーかどうか確認
    def correct_user
      # GET /users/:id/edit
      # PATCH /users/:id
      @user = User.find(params[:id])
      #redirect_to(root_url) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user)
    end
end
