class ProductsController < ApplicationController
  def index
    @products = Product.all
    if request.xhr?
      @results = Product.filter_results(params["filter"])
      respond_to do |format|
        format.html
        format.json { render json: @results }
      end
    end
  end

  def show
    @order_item = current_order.order_items.new
    if Conversation.between(current_user.id, 1).empty?
      @conversation = Conversation.create(author_id: current_user.id, receiver_id: 1)
    else
      @conversation = Conversation.between(current_user.id, 1)[0]
    end
  end

  def landing_page
    #code
  end
end
