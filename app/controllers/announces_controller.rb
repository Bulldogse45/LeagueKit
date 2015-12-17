class AnnouncesController < ApplicationController

  before_filter :load_announcable

  def index
    @announces = @announcable.announces
  end

  def new
    @announce = Announce.new
  end

  def create
    @announce = @announcable.announces.new(announce_params)
    if @announce.save
      flash[:notice] = "Announcement successful!"
      redirect_to [@announcable, :announces]
    else
      flash[:alert] = @announce.errors
      render 'new'
    end
  end

  private

  def load_announcable
    resource, id = request.path.split('/')[1,2]
    @announcable = resource.singularize.classify.constantize.find(id)
  end

  def announce_params
    params.require(:announce).permit(:content)
  end
end
