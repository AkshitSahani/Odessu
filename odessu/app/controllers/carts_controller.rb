class CartsController < ApplicationController
  def show
    @order_items = current_order.order_items
    @amount = current_order.subtotal.round(2)
    @tax = (@amount * 0.13).round(2)
    @charge = @amount + @tax
  end
end
