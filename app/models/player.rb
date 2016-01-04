class Player < ActiveRecord::Base

  validates_presence_of :date_of_birth, :user_id, :first_name, :last_name

  attachment :player_photo, content_type: ["image/jpeg", "image/png", "image/gif"]
  belongs_to :user
  has_many :player_participants
  has_many :teams, through: :player_participants

  def full_name
    suffix = ""
    if self.suffix != nil && self.suffix != ""
      suffix = ", #{self.suffix}"
    end
    return "#{self.first_name} #{self.last_name}#{suffix}"
  end

end
