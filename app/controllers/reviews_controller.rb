class ReviewsController < ActionController::Base
  include RequireAuthentication
  include Pagination

  respond_to :json
  before_action :require_authentication
  before_action :require_verification

  def index
    @reviews = authenticated_user.reviews.page(current_page).per(per_page)
    pagination_headers(@reviews.total_pages)
  end
end
