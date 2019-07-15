class User < ActiveRecord::Base
    has_many :posts
    has_many :commenters, through: :posts
    has_many :followers
end