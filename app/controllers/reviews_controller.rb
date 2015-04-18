class ReviewsController < ActionController::Base
  include RequireAuthentication
  include Pagination
  include CheckPlan

  respond_to :json
  before_action :require_authentication
  before_action :require_verification
  before_action :check_plan, only: [:update]
  before_action only: [:update] do
    require_ownership(Question)
  end

  def index
    @reviews = authenticated_user.reviews.page(current_page).per(per_page)
    pagination_headers(@reviews.total_pages)
  end

  def update
    @item = Question.find_by_id params['id']
    if @item.reviewable?
      if params.key? 'correct'
        if params['correct']
          @item.correct
        else
          @item.incorrect
        end

        render template: 'items/show'
      else
        render :update_malformed, status: 401
      end
    else
      render template: 'not_found', status: 404
    end
  end
end
