# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    #UserMailer.account_activation
    
    #リスト 11.18: アカウント有効化のプレビューメソッド (完成)
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user) # -> mail object
    
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    #UserMailer.password_reset
  
    #リスト 12.10: パスワード再設定のプレビューメソッド
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user) # -> mail object
  
  end

end
