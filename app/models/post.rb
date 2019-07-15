class Post < AvtiveRecord::Base
    belongs_to :user
    has_many :comment
end