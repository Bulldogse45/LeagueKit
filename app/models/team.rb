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
    Game.where("home_team_id = #{self.id} OR away_team_id = #{self.id}")
  end
end
