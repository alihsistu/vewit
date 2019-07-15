class User < ActiveRecord::Base
    has_many :tweets
    has_many :repliers, through: :tweets
    has_many :followers
end