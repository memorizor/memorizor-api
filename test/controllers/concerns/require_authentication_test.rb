require 'json'

class RequireAuthenticationTest < ActionController::TestCase
  # Use user#get to test RequireAuthentication concern
  test 'Returns an error without a token required' do
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
end
