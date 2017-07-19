class MessagesController < ApplicationController
  before_action :find_conversation!

  def new
    redirect_to conversation_path(@conversation) and return if @conversation
    @message = current_user.sent_messages.build

      respond_to do |format|
        format.html { render :layout => false if request.xhr? }
    end
  end

  def create
    # byebug
    @conversation ||= Conversation.create(author_id: current_user.id, receiver_id: @receiver.id)
    @message = current_user.sent_messages.build(body: params[:message][:body], receiver_id: @receiver.id)
    @message.conversation_id = @conversation.id
    @message.save

    flash[:notice] = "Your message was sent!"
    redirect_to conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:message).permit(:body, :author_id, :receiver_id, :conversation_id)
  end

  def find_conversation!
    if params[:receiver_id]
      @receiver = User.find(params[:receiver_id])
      redirect_to(root_path) and return unless @receiver
      @conversation = Conversation.between(current_user.id, @receiver.id)[0]
    elsif params[:message_receiver_id]
        @receiver = User.find(params[:message_receiver_id])
        redirect_to(root_path) and return unless @receiver
        @conversation = Conversation.between(current_user.id, @receiver.id)[0]
    else
      @conversation = Conversation.find(params[:conversation_id])
      redirect_to(root_path) and return unless @conversation && @conversation.participates?(current_user)
    end
  end

end
