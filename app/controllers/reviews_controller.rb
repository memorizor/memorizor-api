class ReviewsController < ActionController::Base
  include RequireAuthentication
  include Pagination

  respond_to :json
  before_filter :require_authentication
  before_filter :require_verification

  def index
    @reviews = authenticated_user.reviews.page(current_page).per(per_page)
    pagination_headers(@reviews.total_pages)
  end
end
