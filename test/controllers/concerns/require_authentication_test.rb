require 'json'

class RequireAuthenticationTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  # Use user#get to test RequireAuthentication concern
  test 'Returns an error without a token' do
    @controller = UsersController.new
    get :get

    assert_response 400
    assert_equal [-1], JSON.parse(@response.body)['errors']
  end

  test 'Returns a token invalid error' do
    @controller = UsersController.new
    get :get, token: 'invalid token'

    assert_response 401
    assert_equal [401], JSON.parse(@response.body)['errors']
  end

  # Use Items#index to test require_verification
  test 'Throws a error with a unverified user' do
    token = Token.generate users(:testing).id
    @controller = ItemsController.new
    get :index, token: token

    assert_response 403
    assert_equal [403], JSON.parse(@response.body)['errors']

    Token.delete(token)
  end

  test 'Works with a verfied user' do
    token = Token.generate users(:verified_user).id
    @controller = ItemsController.new
    get :index, token: token

    assert_response :success

    Token.delete(token)
  end
end
