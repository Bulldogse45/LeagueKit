class WelcomeController < ApplicationController

  def index
    @following = current_user.all_following
  end

end
