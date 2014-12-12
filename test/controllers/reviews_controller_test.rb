require 'json'

class ReviewsControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  test 'index works' do
    token = Token.generate users(:super_active_user).id
    get :index, token: token, per: 25, page: 2

    assert_response :success
    assert_equal 25, JSON.parse(@response.body).length
    assert_equal 2, @response.headers['TOTAL-PAGES']
    assert_equal 2, @response.headers['CURRENT-PAGE']

    Token.delete token
  end
end
