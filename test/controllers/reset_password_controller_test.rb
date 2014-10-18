require 'minitest/mock'
require 'json'

class ResetPasswordControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  test 'Creates a reset token from email and uses it to change password' do
    reset_token = 'this is a reset token'

    SecureRandom.stub :urlsafe_base64, reset_token do
      post :create, email: users(:testing).email

      assert_response :success

      post :valid, reset_token: reset_token

      assert_response :success
      assert_equal true, JSON.parse(@response.body)['valid']

      post :index, reset_token: reset_token, password: 'new password'

      assert_response :success
      assert User.find_by_id(users(:testing).id)
                 .try(:authenticate, 'new password')

      post :valid, reset_token: reset_token

      assert_response :success
      assert_equal false, JSON.parse(@response.body)['valid']
    end
  end

  test 'Does nothing with invalid  or nonexistant email' do
    reset_token = 'this is a reset token that should never be created'

    SecureRandom.stub :urlsafe_base64, reset_token do
      post :create, email: 'invalid email'

      assert_response :success

      post :valid, reset_token: reset_token

      assert_response :success
      assert_equal false, JSON.parse(@response.body)['valid']
    end
  end

  test 'valid returns an error when no token is provided' do
    post :valid

    assert_response 400
  end

  test 'index returns an error when no paramaters are provided' do
    post :index

    assert_response 400
    assert_equal [1, 2], JSON.parse(@response.body)['errors']
  end

  test 'index returns an error when no token is provided' do
    post :index, password: 'unauthorized'

    assert_response 400
    assert_equal [1], JSON.parse(@response.body)['errors']
  end

  test 'index returns an error when no password is provided' do
    post :index, reset_token: 'invalid token'

    assert_response 400
    assert_equal [2], JSON.parse(@response.body)['errors']
  end
end
