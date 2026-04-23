class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:room_id])
    stream_for conversation
  end

  def unsubscribed
  end
end