class Team < ActiveRecord::Base

  acts_as_followable
  has_many :announces, as: :announcable
  validates_presence_of :name

  attachment :team_logo, content_type: ["image/jpeg", "image/png", "image/gif"]
  belongs_to :tournament
  belongs_to :user
  has_many :player_participants
  has_many :games
  has_many :players, through: :player_participants

  def display_name
    if self.tournament
      "#{self.name}-#{self.tournament.name}"
    else
      "#{self.name}-main"
    end
  end

  def tournaments
    original_team = Team.find(self.original_id)
    teams = Team.where("original_id = #{self.id}")
    team_tournys = []
    teams.each do |t|
      if t.tournament_id
        team_tournys << Tournament.find(t.tournament_id)
      end
    end
    team_tournys
  end

  def games
    games = []
    if self.original_id != self.id
      games = Game.where("home_team_id = #{self.id} OR away_team_id = #{self.id}")
    else
      Team.where("original_id = #{self.id}").each do |t|
        Game.where("home_team_id = #{t.id} OR away_team_id = #{t.id}").each do |g|
          games << g
        end
      end
    end
    games.sort_by{|g| g.begin_time}
  end

  def self.search(search)
    if search
      Team.where('id = original_id AND name LIKE ?', "%#{search}%")
    else
      Team.where(:all)
    end
  end

end
