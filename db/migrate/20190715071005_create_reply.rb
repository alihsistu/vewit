class CreateReply < ActiveRecord::Migration[5.2]
  def change
    create_table :replies do |t|
      t.integer  :post_id
      t.string   :replies
      t.integer  :user_id
      t.timestamps
    end
  end
end
