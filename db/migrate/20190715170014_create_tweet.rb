class CreateTweet < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.integer  :user_id
      t.string   :description
      t.integer  :likes
      t.timestamps
    end
  end
end
