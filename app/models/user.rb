class User < ApplicationRecord
  
  attr_accessor :remember_token#getter setter
  
  validates(:name, presence: true, length: { maximum: 50 })
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness:{case_sensitive: false} #unique: true
  
  has_secure_password
  
  #リスト 10.13: パスワードが空のままでも更新できるようにする
  #validates :password, presence: true, length: { minimum: 6 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  
   # 渡された文字列のハッシュ値を返す
  def User.digest(string)#class method （static methodと近い？）、instance methodは インスタンスを作ってから使える
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  
  
  #def remember=(token)
  #  @remember = token
  #end
  
  #def remember
  #  @remember
  #end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))#update_attribute 有効性検査のなしで更新、self省略可能メッソド
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    
    #リスト 9.19: authenticated?を更新して、ダイジェストが存在しない場合に対応 
    return false if remember_digest.nil?
    
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    self.update_attribute(:remember_digest, nil)#remember_digest nullにする
  end
  
end
