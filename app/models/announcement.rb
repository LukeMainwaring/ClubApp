class Announcement < ActiveRecord::Base
    validates :announcement, presence: true, length: { minimum: 2 }
end
