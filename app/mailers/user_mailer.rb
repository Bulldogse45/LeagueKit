class UserMailer < ApplicationMailer

  default :from => "LeagueKit@gmail.com"

  def announcement_notification(user)
    mail(:to => user.email, :subject => "There was an announcement in LeagueKit")
  end

  def create_confirmation(user)
    mail(:to => user.email, :subject => "Welcome to LeagueKit")
  end

  def new_follow(user, followable)
    @followable = followable
    mail(:to => user.email, :subject => "Welcome to the #{followable.class} - #{followable.name}")
  end
end
