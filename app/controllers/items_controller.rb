class ItemsController < ActionController::Base
  include RequireAuthentication
  respond_to :json
  before_filter :require_authentication
  before_filter :require_verification
  before_filter :require_ownership, only: [:show, :update, :destroy]

  def index
    @user = authenticated_user
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
    @question = Question.find_by_id params['id']
    @question.content = params['content'] if params.key?(:content)
    @question.answer_type = params['type'] if params.key?(:type)

    if @question.invalid?
      render :create_question_malformed, status: 400
    else
      @question.save!

      if params.key?(:answers)
        @question.answers.each(&:destroy)

        params['answers'].each do |content|
          @answer = @question.answers.new(content: content).save!
        end
      end
    end
  end

  def destroy
    Question.destroy params['id']
  end

  private

  def require_ownership
    @question = Question.find_by_id(params['id'])
    @user = User.find_by_id(Token.authenticate(params['token']))

    render template: 'not_found', status: 404 if
      @question.nil? || @question.user_id != @user.id
  end
end
