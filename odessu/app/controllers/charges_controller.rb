class ChargesController < ApplicationController
  def new
    @amount = current_order.subtotal.round(2)
    @tax = (@amount * 0.13).round(2)
    @charge = (@amount + @tax)
  end

  def create
    # Amount in cents
    @amount = current_order.subtotal.round(2)
    @tax = (@amount * 0.13).round(2)
    @charge = @amount + @tax
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => (@charge * 100).to_i, #because stripe expects charges in cents
      :description => 'Rails Stripe customer',
      :currency    => 'cad'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
