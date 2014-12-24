class CatagoriesController < ActionController::Base
  include RequireAuthentication
  include Pagination

  respond_to :json
  before_action :require_authentication
  before_action :require_verification
  before_action only: [:show, :update, :destroy] do
    require_ownership(Catagory)
  end

  def index
    @page = authenticated_user.catagories.page(current_page).per(per_page)
    @items_max = params['items_max'].to_i
    pagination_headers(@page.total_pages)
  end

  def create
    @user = authenticated_user
    @catagory = @user.catagories.new name: params['name'],
                                     color: (params['color'] || '').downcase

    @catagory.add_questions((params['questions'] || []), @user)

    if @catagory.invalid?
      render :create_malformed, status: 400
    else
      @catagory.save!
    end
  end

  def show
    @catagory = Catagory.find_by_id params['id']
  end

  def update
    @catagory = Catagory.find_by_id params['id']
    @catagory.name = params['name'] if params.key?(:name)
    @catagory.color = params['color'] if params.key?(:color)

    if @catagory.invalid?
      render :create_malformed, status: 400
    else
      @catagory.save!

      if params.key?(:questions)
        @catagory.questions.clear
        @catagory.add_questions(params['questions'], authenticated_user)
      end
    end
  end

  def destroy
    Catagory.destroy params['id']
  end
end
