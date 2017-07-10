class OrderItemsController < ApplicationController
  def create
      @order = current_order
      @order_items = @order.order_items
      if @order_items.where(product_id: order_item_params['product_id']).empty?
        @order_item = @order.order_items.new(order_item_params)
      else
        @order_item = @order_items.where(product_id: order_item_params['product_id']).first
        @order_item.quantity += order_item_params["quantity"].to_i
      end
      # byebug
      @order_item.save
      @order.save
      session[:order_id] = @order.id
    end

    def update
      @order = current_order
      @order_item = @order.order_items.find(params[:id])
      @order_item.update_attributes(order_item_params)
      @order_items = @order.order_items
    end

    def destroy
      @order = current_order
      @order_item = @order.order_items.find(params[:id])
      @order_item.destroy
      @order_items = @order.order_items
    end
  private
    def order_item_params
      params.require(:order_item).permit(:order_id, :unit_price, :quantity, :product_id)
    end
end
