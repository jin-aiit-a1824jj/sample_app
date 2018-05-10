class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com' #リスト 11.11: fromアドレスのデフォルト値を更新したアプリケーションメイラー
  layout 'mailer'
end
