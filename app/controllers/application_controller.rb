class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper #ApplicationControllerを継承していれば、インクルード。。。
  
  def hello
    render html: "hello, world!"
  end
end
