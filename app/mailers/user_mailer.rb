class UserMailer < ApplicationMailer


  default :from => "LeagueKit@gmail.com"

  def announcement_notification(user, announce)
    unless user.email_optout
      @announce = announce
      mail(:to => user.email, :subject => "There was an announcement in LeagueKit")
    end
  end

  def message_notification(user, message)
    unless user.email_optout
      @message = message
      mail(:to => user.email, :subject => "You received a message in LeagueKit")
    end
  end

  def create_confirmation(user)
    unless user.email_optout
      mail(:to => user.email, :subject => "Welcome to LeagueKit")
    end
  end

  def new_follow(user, followable)
    unless user.email_optout
      @followable = followable
      mail(:to => user.email, :subject => "Welcome to the #{followable.class} - #{followable.name}")
    end
  end
end
