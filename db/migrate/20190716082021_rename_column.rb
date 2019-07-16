class RenameColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :followers, :user_id, :following_id
  end
end
