require 'stripe'

Stripe.api_key = ENV['STRIPE_SECRET_KEY']
StripeEvent.signing_secret = ENV["SIGNING_SECRET"]
StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|
    ProducerPolicyPaid.publish(event.data.object)
  end
end
