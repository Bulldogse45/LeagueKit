class MessagesController < ApplicationController
  before_action :require_user

  def index
    @messages = Message.all.select{|l| l.to_users_ids.include?(current_user.id.to_s)}
  end

  def sent
    @messages = Message.where("from_user_id = #{current_user.id}")
    render 'index'
  end

  def show
    @message = Message.find(params['id'])
    if @message.to_users_ids.split(",").include?(current_user.id.to_s) || @message.from_user_id == current_user.id
      @related_messages = []
      start_message = @message
      while start_message.index_message_id
        @related_messages.prepend(Message.find(start_message.index_message_id))
        start_message = Message.find(start_message.index_message_id)
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
      unless to_users.include?(User.find(@reply_message.from_user_id).username)
        to_users = to_users.join(", ") + ", #{User.find(@reply_message.from_user_id).username}"
      else
        to_users = to_users.join(", ")
      end
      @message.to_users_list = to_users
      @message.subject = "Re: "+ @reply_message.subject
    end
    if params['user_id']
      @message.to_users << ToUser.new(user_id:params['user_id'])
    end
    if params['coaches']
      params['coaches'].each do |c|
        @message.to_users << ToUser.new(user_id:c)
      end
    end
    if params['referees']
      Tournament.find(params['referees']).referees.each do |c|
        @message.to_users << ToUser.new(user_id:c.user_id)
      end
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
        @message.to_users_ids.split(",").each do |u|
          UserMailer.message_notification(User.find(u.to_i), @message).deliver
        end
        redirect_to message_path(@message)
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
    params.require(:message).permit(:to_users_list, :subject, :content, :index_message)
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
    User.where("username = '#{username.strip}'").first
  end

end
