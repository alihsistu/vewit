class CreateFollower < ActiveRecord::Migration[5.2]
  def change
    create_table :followers do |t|
      t.integer :user_id
      t.integer :follower_id
  end
end
