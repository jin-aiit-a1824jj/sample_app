class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    
    #リスト 14.1: relationshipsテーブルにインデックスを追加する
    add_index :relationships, :follower_id#高速化のためのindex
    add_index :relationships, :followed_id#高速化のためのindex
    add_index :relationships, [:follower_id, :followed_id], unique: true#一意性のためのindex
    
  end
end
