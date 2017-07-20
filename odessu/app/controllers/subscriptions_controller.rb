class SubscriptionsController < ApplicationController
  def new
    #show the initial form to provide information, and an i agree button. correct
    #input of card data and presence of checked param for i agree button will call
    #on the create function. Use form tag here, that calls on the create function.
  end

  def create
    customer = Stripe::Customer.create(
      :email => current_user.email,
    )

    Stripe::Subscription.create(
      :customer => customer.id,
      :plan => "basic-monthly", #call this whatever Leon names his plan.
    )
  end
end
