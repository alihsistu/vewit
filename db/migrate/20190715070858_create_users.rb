class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :username
      t.integer :post_id
      t.integer :comment_id
      t.integer :likes
      t.timestamps
  end
end
