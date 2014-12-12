class ReviewsController < ActionController::Base
  include RequireAuthentication
  respond_to :json
  before_filter :require_authentication
  before_filter :require_verification

  def index
    @current_page = params['page'] || 1
    @per = params['per'] || 10
    @reviews = authenticated_user.reviews.page(@page).per(@per)
    response.headers['TOTAL-PAGES'] = @reviews.total_pages
    response.headers['CURRENT-PAGE'] = @current_page.to_i
  end
end
