class ItemsController < ActionController::Base
  include RequireAuthentication
  include Pagination

  respond_to :json
  before_action :require_authentication
  before_action :require_verification
  before_action only: [:show, :update, :destroy] do
    require_ownership(Question)
  end

  def index
    @page = authenticated_user.questions.page(current_page).per(per_page)
    pagination_headers(@page.total_pages)
  end

  def create
    @user = authenticated_user
    @item = @user.questions.new content: params['content'], review_at: Time.now,
                                answer_type: params['type']
    if @item.invalid?
      render :create_question_malformed, status: 400
    else
      @item.save!

      params['answers'].each do |content|
        @answer = @item.answers.new content: content
        @answer.save!
      end
    end
  end

  def show
    @item = Question.find_by_id params['id']
  end

  def update
    @item = Question.find_by_id params['id']
    @item.content = params['content'] if params.key?(:content)
    @item.answer_type = params['type'] if params.key?(:type)

    if @item.invalid?
      render :create_question_malformed, status: 400
    else
      @item.save!

      if params.key?(:answers)
        @item.answers.each(&:destroy)

        params['answers'].each do |content|
          @answer = @item.answers.new(content: content).save!
        end
      end
    end
  end

  def destroy
    Question.destroy params['id']
  end
end
