class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
  end

  def create
    other_user = User.find(params[:other_user_id])
    
    @conversation = Conversation.find_or_create_direct_chat(current_user, other_user)
    
    redirect_to conversation_path(@conversation)
  end

  def show
    @conversation = current_user.conversations.find(params[:id])
    @messages = @conversation.messages.order(created_at: :asc)
    
    @users = User.where.not(id: current_user.id)
  end
end