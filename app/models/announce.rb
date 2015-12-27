class Announce < ActiveRecord::Base

  belongs_to :announcable, polymorphic: true
  has_one :announcement_viewed

  def read?
    self.announcement_viewed.viewed
  end
end
