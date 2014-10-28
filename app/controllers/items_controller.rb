class ItemsController < ActionController::Base
  include RequireAuthentication
  respond_to :json
  before_filter :require_authentication
  before_filter :require_verification

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
