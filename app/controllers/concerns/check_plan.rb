module CheckPlan
  extend ActiveSupport::Concern
  include RequireAuthentication

  def check_plan
    render template: 'plan_broken', status: 403 unless
      authenticated_user.within_plan?
  end

  def creation_permitted
    render template: 'cannot_create', status: 403 unless
      authenticated_user.can_create?
  end
end
