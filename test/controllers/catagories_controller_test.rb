require 'json'

class CatagoriesControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  # Use Catagories#show to test require_ownership

  test 'Throws 404 when catafory does not exist' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: 123_456_789

    assert_response 404
    assert_equal [404], JSON.parse(@response.body)['errors']
  end

  test 'Throws 404 when user is not the owner' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: catagories(:other_catagory).id

    assert_response 404
    assert_equal [404], JSON.parse(@response.body)['errors']
  end

  test 'Works when user is the owner' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: catagories(:test_catagory).id

    assert_response :success
    # assert_equal questions(:test).id, JSON.parse(@response.body)['id']
  end
end
