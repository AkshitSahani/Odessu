class ChargesController < ApplicationController
  def new
    # byebug
    @amount = current_order.subtotal.round(2)
    @tax = (@amount * 0.13).round(2)
    @charge = (@amount + @tax)
  end

  def create
    # Amount in cents
    @amount = current_order.subtotal.round(2)
    @tax = (@amount * 0.13).round(2)
    @charge = @amount + @tax

    if current_user.stripe_customer_id

      charge = Stripe::Charge.create(
        :customer    => current_user.stripe_customer_id,
        :amount      => (@charge * 100).to_i, #because stripe expects charges in cents
        :description => 'Rails Stripe customer',
        :currency    => 'cad'
      )

    else

      customer = Stripe::Customer.create(
        :email => current_user.email,
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => (@charge * 100).to_i, #because stripe expects charges in cents
        :description => 'Rails Stripe customer',
        :currency    => 'cad'
      )

    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
