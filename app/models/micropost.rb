class Micropost < ApplicationRecord
  belongs_to :user
  #belongs_to:(所有者), マイクロポストがユーザーに所属する (belongs_to) 関連付け
  
  #リスト 13.17: default_scopeでマイクロポストを順序付ける
  default_scope -> { order(created_at: :desc) } #SQLの降順 (descending) / デフォルトの順序は昇順 (ascending) 
  
  #リスト 13.59: Micropostモデルに画像を追加する
  mount_uploader :picture, PictureUploader
  
  #リスト 13.5: マイクロポストのuser_idに対する検証
  validates :user_id, presence: true
  #リスト 13.8: Micropostモデルのバリデーション
  validates :content, presence: true, length: { maximum: 140 }
  
  #リスト 13.65: 画像に対するバリデーションを追加する
  validate  :picture_size
  
  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 1.megabytes
        errors.add(:picture, "should be less than 1MB")
      end
    end
  
end
