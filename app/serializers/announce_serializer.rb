class AnnounceSerializer < ActiveModel::Serializer

  attributes :id,  :content
  has_one :announcable, serializer: AnnouncableSerializer


end
