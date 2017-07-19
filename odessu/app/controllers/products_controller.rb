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
  end
end
