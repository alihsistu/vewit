class User < ActiveRecord::Base
    has_many :posts, foreign_key: :user_id, dependent: :destroy
    has_many :repliers, through: :posts
    has_many :followers, foreign_key: :follower_id, class_name: "Follower", dependent: :destroy
<<<<<<< Updated upstream
    validates_presence_of :username
    validates_uniqueness_of :username
=======


    # validates_presence_of :name,:username, :email
    # validates :email, uniqueness: true

>>>>>>> Stashed changes
    has_secure_password


    def self.follow(username,current_user)
        # followed << users
        # byebug
        user = User.find_by_username(username)
        id = current_user.id
        follow =Follower.create(follower_id:id,following_id:user.id)
    end

    def self.unfollow(username,current_user)
      # followed << users
      # byebug
      user = User.find_by_username(username)
      id = current_user.id
      unfollow =Follower.destroy(follower_id:id,following_id:user.id)
  end
    
    
    # Returns true if the current user is following the other user.
    def self.following?(id,current_user)
      user =Follower.find_by(following_id:id)
      if user.nil?
        return false
      elsif !user.following_id==current_user.id
        return false
      else
        true
      end
    end
    
    def self.search(search)
        where('name ILIKE :user_name or username ILIKE :user_name', user_name: :"%#{search}%")
    end


end
