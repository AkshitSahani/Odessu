class ProductsController < ApplicationController
  def index
    @products = Product.all  
  end

  def show
    @order_item = current_order.order_items.new
  end
end
