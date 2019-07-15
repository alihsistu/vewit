class Follower < ActiveRecord::Base
    belongs_to :user_id , {class_name: 'User'}
    belongs_to :folower_id, {class_name: 'User'}

end