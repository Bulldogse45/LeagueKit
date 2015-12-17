class Announce < ActiveRecord::Base

  belongs_to :announcable, polymorphic: true
end
