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
    @user = authenticated_user
    @catagory = @user.catagories.new name: params['name'],
                                     color: (params['color'] || '').downcase

    (params['questions'] || []).each do |question_id|
      @catagory.questions << Question.find_by_id(question_id)
    end

    if @catagory.invalid?
      render :create_malformed, status: 400
    else
      @catagory.save!
    end
  end

  def show
    render nothing: true
  end

  def update
    render nothing: true
  end

  def destroy
    Catagory.destroy params['id']
  end
end
