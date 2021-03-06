class ConversationsController < ApplicationController
  before_action :set_conversation, except: [:index]
  before_action :check_participating!, except: [:index]

  def index
     @conversations = Conversation.participating(current_user).order('updated_at DESC')
     respond_to do |format|
       format.html
       format.js
     end
  end

  def show
    @message = Message.new
      respond_to do |format|
        format.html { render :layout => false if request.xhr? }
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def check_participating!
    redirect_to root_path unless @conversation && @conversation.participates?(current_user)
  end

end
