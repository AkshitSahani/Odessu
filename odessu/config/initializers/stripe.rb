#Stripe setup for checkout payments
Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}
#your own publishable and secret keys go above. From Stripe Dashboard

Stripe.api_key = Rails.configuration.stripe[:secret_key]

#Stripe setup for subscription plans

# plan = Stripe::Plan.create(
#   :name => "Basic Plan",
#   :id => "basic-monthly",
#   :interval => "month",
#   :currency => "cad",
#   :amount => 500,     #amount in cents
# )
#
# customer = Stripe::Customer.create(
#   :email => current_user.email,
# )
#
# Stripe::Subscription.create(
#   :customer => customer.id,
#   :plan => "basic-monthly",
# )

#redirect after initial sign up info to subscription page. Most likely
#will be the checkout page. But send some params this time like "subscription"
#nad if that param is present, charge 5 or else, normal checkout. Putting in the correct
#info here will call on to a method on the subscription controller, wihch will create
#the subscription for the user, based on email. Then look at tutorial to implement web
#hooks.
