class User < ActiveRecord::Base
    has_many :posts
    has_many :repliers, through: :posts
    has_many :followers
end