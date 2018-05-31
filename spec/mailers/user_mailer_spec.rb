
require 'spec_helper'
require 'rails_helper'

describe 'user_mailer', :type => :mailer do
  
 #リスト 11.20: 現在のメールの実装をテストする
  it "account_activation" do
    user = create(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    
    expect(mail.subject).to eq "Account activation"
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq ["noreply@example.com"]
    
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end


  #リスト 12.12: パスワード再設定用メイラーメソッドのテストを追加する
  it "password_reset" do
    user = create(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    
    expect(mail.subject).to eq "Password reset"
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq ["noreply@example.com"]

    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  
end

