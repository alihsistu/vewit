class User < ActiveRecord::Base
    has_many :posts, foreign_key: :user_id, dependent: :destroy
    has_many :repliers, through: :posts
    has_many :followers, foreign_key: :follower_id, class_name: "Follower", dependent: :destroy
    validates_presence_of :username
    validates_uniqueness_of :username
    has_secure_password


    def follow!(user)
        followed << user
    end
    
    
    # Returns true if the current user is following the other user.
    def following?(user)
    followed.include?(user) 
    end
    
    def self.search(search)
        where('name ILIKE :user_name or username ILIKE :user_name', user_name: :"%#{search}%")
    end


end
