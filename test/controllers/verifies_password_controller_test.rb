require 'minitest/mock'
require 'json'

class VerifiesControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  test 'Creates a verification token and uses it' do
    verification_token = 'this is a verification token'
    token = Token.generate users(:testing).id

    SecureRandom.stub :urlsafe_base64, verification_token do
      post :create, token: token

      assert_response :success
      assert_not_equal [1], JSON.parse(@response.body)['errors']

      get :index, verification_token: verification_token

      assert_response :success
      assert_equal true, User.find_by_id(users(:update_test).id).verified

      post :create, token: token

      assert_response :success
      assert_equal [1], JSON.parse(@response.body)['errors']
    end
  end

  test 'create does not let you verify again' do
    token = Token.generate users(:verified_user).id
    post :create, token: token

    assert_response :success
    assert_equal [1], JSON.parse(@response.body)['errors']
  end

  test 'index returns an error when no verification token is provided' do
    get :index

    assert_response 400
    assert_equal [1], JSON.parse(@response.body)['errors']
  end
end
