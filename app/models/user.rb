class User < ActiveRecord::Base
    has_many :posts, foreign_key: :user_id, dependent: :destroy
    has_many :repliers, through: :posts
    has_many :followers, foreign_key: :follower_id, class_name: "Follower", dependent: :destroy


    validates_presence_of :name,:username, :email
    # validates :email, uniqueness: true

    has_secure_password
    #to use later

    # include BCrypt
  
    # def password
    #   @password ||= Password.new(password_hash)
    # end
  
  
    # def password=(new_password)
    #   @password = Password.create(new_password)
    #   self.password_hash = @password
    # end


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