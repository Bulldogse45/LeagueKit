class MessagesController < ApplicationController
  before_action :require_user

  def index
    @messages = Message.where("to_user_id = #{current_user.id}")
  end

  def show
    @message = Message.find(params['id'])
    @related_messages = []
    start_message = @message
    while start_message.index_message_id
      @related_messages.prepend(Message.find(start_message.index_message_id))
      start_message = Message.find(start_message.index_message_id)
    end
  end

  def new
    @message = Message.new
    if params['id'] && Message.find(params['id']).to == current_user
      @reply_message = Message.find(params['id'])
      @message.to_user_id = @reply_message.from.id
    end
  end

  def create

    @message = Message.new(message_params_less_index)
    if Message.find(params[:message][:index_message_id]).to == current_user
      @message.index_message_id = params[:message][:index_message_id]
    end
    @message.from_user_id = current_user.id
    if @message.save
      redirect_to message_path(@message)
    else
      render 'new'
    end
  end

  private

  def message_params_less_index
    params.require(:message).permit(:to_user_id, :subject, :content, :index_message)
  end

end
