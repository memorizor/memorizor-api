class ItemsController < ActionController::Base
  include RequireAuthentication
  respond_to :json
  before_filter :require_authentication
  before_filter :require_verification

  def index
    render nothing: true
  end

  def create
    @user = authenticated_user
    @item = @user.questions.new content: params['content'], review_at: Time.now,
                                answer_type: params['type']
    if @item.invalid?
      render :create_question_malformed, status: 400
    else
      @item.save!
    end
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
