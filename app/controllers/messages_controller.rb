class MessagesController < ApplicationController
  before_action :require_user

  def index
    @messages = Message.all.order("created_at DESC").select{|l| l.to_users_ids.include?(current_user.id.to_s)}
  end

  def sent
    @messages = Message.where("from_user_id = ?", current_user.id).order("created_at DESC")
    render 'index'
  end

  def show
    @message = Message.find(params['id'])
    if @message.player_id
      @player = Player.find(@message.player_id)
      @player_participant = PlayerParticipant.new
    end
    if @message.team_id
      @team = Team.find(@message.team_id)
    end
    if @message.to_users_ids.split(",").include?(current_user.id.to_s) || @message.from_user_id == current_user.id
      @related_messages = []
      start_message = @message
      while start_message.index_message_id
        @related_messages.prepend(Message.find(start_message.index_message_id))
        start_message = Message.find(start_message.index_message_id)
      end
      if @message.from != current_user || @message.to_users_ids.include?(current_user.id.to_s)
        MessageRead.where("message_id = ? AND user_id = ?", @message.id, current_user.id).first.update(read:true)
      end
    else
      flash.now[:alert] = "This message is not yours to see!"
      redirect_to :root
    end
  end

  def new
    @message = Message.new
    if params['id'] && Message.find(params['id']).to_users_ids.split(",").include?(current_user.id.to_s)
      @reply_message = Message.find(params['id'])
      to_users = @reply_message.to_users_list.split(", ")
      to_users -= [@reply_message.to_users.where("user_id = ?", current_user.id).first.user.username]
      to_users << User.find(@reply_message.from_user_id).username
      to_users = to_users.join(", ")

      @message.to_users_list = to_users
      @message.subject = "Re: "+ @reply_message.subject
    end
    if params['user_id']
      @message.to_users << ToUser.new(user_id:params['user_id'])
    end
    if params['tournament_id']
      @tournament = Tournament.find(params['tournament_id'])
      @tournament.coaches.each do |c|
        @message.to_users << ToUser.new(user_id:c.id)
      end
    end
    if params['referees']
      Tournament.find(params['referees']).referees.each do |c|
        @message.to_users << ToUser.new(user_id:c.user_id)
      end
    end
    if params['team_id'] && params['player_id'] && current_user == Player.find(params['player_id']).user
      @team = Team.find(params['team_id'])
      @player = Player.find(params['player_id'])
      @message.to_users << ToUser.new(user_id:@team.user_id)
      @message.subject = "#{@player.full_name} would like to join #{@team.name}"
      @team_request = true
    end
  end

  def create
    if all_to_users_exist == ""
      @message = Message.new(message_params)
      if params[:message][:index_message_id] && Message.find(params[:message][:index_message_id]).to_users_ids.include?(current_user.id.to_s)
        @message.index_message_id = params[:message][:index_message_id]
      end
      @message.from_user_id = current_user.id
      if @message.save
        MessageRead.create(user_id:current_user.id,message_id:@message.id)
        @message.to_users_ids.split(",").each do |u|
          @player_participant = PlayerParticipant.new
          unless @message.from.id.to_s == u
            MessageRead.create(user_id:u.to_i,message_id:@message.id)
          end
          UserMailer.message_notification(User.find(u.to_i), @message).deliver
        end
        redirect_to messages_path
      else
        render 'new'
      end
    else

      flash.now[:danger] = all_to_users_exist
      remove_nonexistent_users
      @message = Message.new(message_params)
      render 'new'
    end
  end

  private

  def message_params
    params.require(:message).permit(:to_users_list, :subject, :content, :index_message, :team_id, :player_id, :team_request)
  end

  def all_to_users_exist
    alert = ""
    users = params[:message][:to_users_list].split(",")
    users.each do |u|
      unless username_lookup(u)
        alert += "#{u} is not a user in our database.  "
      end
    end
    alert
  end

  def remove_nonexistent_users
    users = params[:message][:to_users_list].split(",")
    users_to_remove =[]
    users.each do |u|
      unless username_lookup(u)
        users_to_remove << u
      end
    end
    users = users - users_to_remove
    params[:message][:to_users_list] = users.join(", ")
  end

  def username_lookup(username)
    User.find_by username: username.strip
  end

end
