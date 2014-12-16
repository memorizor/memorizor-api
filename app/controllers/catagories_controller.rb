class CatagoriesController < ActionController::Base
  include RequireAuthentication
  include Pagination

  respond_to :json
  before_filter :require_authentication
  before_filter :require_verification
  before_filter only: [:show, :update, :destroy] do
    require_ownership(Catagory)
  end

  def index
    render nothing: true
  end

  def create
    render nothing: true
  end

  def show
    render nothing: true
  end

  def update
    render nothing: true
  end

  def destroy
    render nothing: true
  end
end
