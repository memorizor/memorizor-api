Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLIC_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.authentication_secret = ENV['STRIPE_WEBHOOK_SECRET']

StripeEvent.configure do |events|
  events.subscribe 'invoice.payment_failed' do |event|
    @user = User.find_by(stripe_id: event.data.object['customer'])
    UserMailer.payment_failed(@user).deliver_now
  end

  events.subscribe 'invoice.payment_succeeded' do |event|
    @user = User.find_by(stripe_id: event.data.object['customer'])
    UserMailer.payment_succeeded(@user, event.data.object).deliver_now
  end

  events.subscribe 'customer.subscription.created' do |event|
    @user = User.find_by(stripe_id: event.data.object['customer'])
    UserMailer.registered_plan(@user, event.data.object).deliver_now
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    @user = User.find_by(stripe_id: event.data.object['customer'])
    @user.plan = 1
    @user.stripe_plan = nil
    @user.save!
    UserMailer.subscription_cancelled(@user).deliver_now
  end
end
