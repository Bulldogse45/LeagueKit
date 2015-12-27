class AnnouncementViewed < ActiveRecord::Base

  belongs_to :announce
  belongs_to :user
end
