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
  end

end
