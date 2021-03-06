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
    "#{self.first_name} #{self.last_name}#{suffix}"
  end

  def username_lookup(username)
    User.find_by username: username
  end

  def age
  now = Time.now.utc.to_date
  birthday = self.date_of_birth
  now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
end

  def games
    games = []
    self.teams.each do |t|
      t.games.each do |g|
        games << g
      end
    end
    games.uniq.sort_by{|g| g.begin_time}
  end

  def self.search(search)
    if search
      Player.where('last_name LIKE ?', "%#{search}%")
    else
      Player.where(:all)
    end
  end

end
