class MessagesController < ApplicationController
  before_action :authenticate_user! # Devise ensures they are logged in

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      ConversationChannel.broadcast_to(
        @conversation,
        {
          message: @message.content,
          user_name: @message.user.name,
          sender_id: @message.user.id,
          created_at: @message.created_at.strftime("%I:%M %p")
        }
      )
      
      head :ok 
    else
      head :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end