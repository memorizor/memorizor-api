class CatagoriesController < ActionController::Base
  include RequireAuthentication
  include Pagination

  respond_to :json
  before_filter :require_authentication
  before_filter :require_verification
  before_filter :require_ownership, only: [:show, :update, :destroy]

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

  private

  def require_ownership
    @question = Question.find_by_id(params['id'])
    @user = User.find_by_id(Token.authenticate(params['token']))

    render template: 'not_found', status: 404 if
      @question.nil? || @question.user_id != @user.id
  end
end
