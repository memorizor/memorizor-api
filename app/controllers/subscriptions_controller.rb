class SubscriptionsController < ActionController::Base
  include RequireAuthentication

  respond_to :json
  before_action :require_authentication
  before_action :require_verification

  def update_plan
    render(:update_plan_malformed) && return unless params.key?('plan')
    render(:invalid_plan) && return if params['plan'] =~ User.PLAN_REGEX
    plan = params['plan'].to_i

    if plan != authenticated_user.plan
      render :card_required, status: 402 if authenticated_user.stripe_id == nil?
      update_stripe_plan(plan)
      authenticated_user.update(plan: plan).save!
    end
    render nothing: true
  end

  def update_customer
    render(:update_customer_malformed, status: 400) && return if
      params.key('stripe_token')

    if authenticated_user.stripe_id == nil?
      c = Stripe::Customer.create(description:
                                  authenticated_user.name << ' @ memorizor',
                                  source: params['stripe_token'])
      authenticated_user.update(stripe_id: c.id).save!
    else
      c = Stripe::Customer.retrieve(authenticated_user.stripe_id)
      c.source = params['stripe_token']
      c.save
    end
    render nothing: true
  rescue Stripe::CardError => e
    @err = e.json_body[:error]
    render :card_error, status: 403
  rescue Stripe::InvalidRequestError => e
    @err = e.json_body[:error]
    render :request_error, status: 403
  end

  def delete_customer
    unless authenticated_user.stripe_id == nil?
      Stripe::Customer.retrieve(authenticated_user.stripe_id).delete
      authenticated_user.update(stripe_id: nil).save!
    end

    render nothing: true
  rescue Stripe::InvalidRequestError => e
    @err = e.json_body[:error]
    render :request_error, status: 403
  end

  private

  def update_stripe_plan(plan)
    c = Stripe::Customer.retrieve(authenticated_user.stripe_id)
    if authenticated_user.stripe_plan == nil?
      s = c.subscriptions.create(plan: 'plan_' << plan)
      authenticated_user.update(stripe_plan: s.id)
    elsif plan == 1
      c.subscriptions.retrieve(authenticated_user.stripe_id).delete
      authenticated_user.update(stripe_plan: nil)
    else
      s = c.subscriptions.retrieve(authenticated_user.stripe_id)
      s.plan = 'plan_' << plan
      s.save
    end
  rescue Stripe::InvalidRequestError => e
    @err = e.json_body[:error]
    render :request_error, status: 403
  end
end
