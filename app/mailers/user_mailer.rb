class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  #def account_activation
  #   @greeting = "Hi"
  #   mail to: "to@example.org" #-> return mail object
    # -> app/views/user_mailer/account_activation.text.erb
    # -> app/views/user_mailer/account_activation.html.erb
  #end

  #リスト 11.12: アカウント有効化リンクをメール送信する
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
    # https://hogehoge.com/account_activations/:id/edit
    # :id <- @user.activation_token
  end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
