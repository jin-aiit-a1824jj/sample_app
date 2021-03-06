class User < ApplicationRecord
  #リスト 13.11: ユーザーがマイクロポストを複数所有する (has_many) 関連付けrail
  #リスト 13.19: マイクロポストは、その所有者 (ユーザー) と一緒に破棄されることを保証する
  has_many :microposts, dependent: :destroy
  
  #リスト 14.2: 能動的関係に対して1対多 (has_many) の関連付けを実装する
  #active_relationships(適当な名前、 明示的に→class_name: "Relationship"、外部キーを明示的に指定（foreign_key: "follower_id"）)
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #=> @user.active_relationships (使えるはず)....
  
  #リスト 14.12: 受動的関係を使ってuser.followersを実装する
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  #リスト 14.8: Userモデルにfollowingの関連付けを追加する
  #followingメッソド定義、active_relationshipsの中で、followedを実行 <- @user.active_relationships.map(&:followed) <- @user.active_relationships.map { |r|  r.followed }
  has_many :following, through: :active_relationships, source: :followed
  
  #リスト 14.12: 受動的関係を使ってuser.followersを実装する
  has_many :followers, through: :passive_relationships, source: :follower
   
  #getter setter
  attr_accessor :remember_token, :activation_token, :reset_token
  #リスト 11.3: Userモデルにアカウント有効化のコードを追加する
  before_save   :downcase_email#before_save →新しく生成か、更新するさい反応
  before_create :create_activation_digest #before_create→メソッド参照, 新しくサインアップ（新しく生成）のみcallback!
  
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
  #def authenticated?(remember_token)
    #リスト 9.19: authenticated?を更新して、ダイジェストが存在しない場合に対応 
    #return false if remember_digest.nil?
    #BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  #end
  def authenticated?(attribute, token)#リスト 11.26: 抽象化されたauthenticated?メソッド
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    self.update_attribute(:remember_digest, nil)#remember_digest nullにする
  end
  
  #リスト 11.35: Userモデルにユーザー有効化メソッドを追加する
  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  #リスト 12.6: Userモデルにパスワード再設定用メソッドを追加する
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  #リスト 12.17: Userモデルにパスワード再設定用メソッドを追加する
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  #リスト 13.46: マイクロポストのステータスフィードを実装するための準備
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  # current_user.feed
  # current_user.id
  # current_user.microposts
  # ユーザーのステータスフィードを返す
  def feed
    #Micropost.where("user_id = ?", self.id)
    #リスト 14.44: とりあえず動くフィードの実装
    #Micropost.where("user_id IN (?) OR user_id = ?", self.following_ids, self.id)
    #sql 式展開→SQLインジェクション問題が起きる可能性が高い！ 上の方法で対策が施している！
    
    #リスト 14.46: whereメソッド内の変数に、キーと値のペアを使う　←シンボル使用
    #Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #following_ids: following_ids,
    #      user_id: id)
          
          
    #リスト 14.47: フィードの最終的な実装 <- 最適化（クエリを一回で済む）
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id) 
          
  end
  
  #リスト 14.10: "following" 関連のメソッド
  # ユーザーをフォローする
  def follow(other_user)
    self.active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    self.following.include?(other_user)
    #[1,2,3,4,5].include?(1) duck_typing <- 裏でsqlで実行される
  end
  
  
  private
    #リスト 11.3: Userモデルにアカウント有効化のコードを追加する
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(self.activation_token)
      # @user.activation_digest => hash値
    end
  
end
