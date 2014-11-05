require 'json'

class UsersControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  test 'Properly creates a user' do
    assert_difference('User.count', 1) do
      post :create, name: 'create_test', email: 'create_test@testing.com',
                    password: 'super secure'
    end

    assert_response :success
  end

  test 'Returns an error with invalid request' do
    post :create

    assert_response 400
    assert_equal [1, 2, 3, 4], JSON.parse(@response.body)['errors']
  end

  test 'Authenticates with username' do
    post :authenticate, name: users(:testing).name,
                        password: 'password'

    assert_response :success

    token = JSON.parse(@response.body)['token']

    assert_equal users(:testing).id.to_s, Token.authenticate(token)

    Token.delete(token)
  end

  test 'Authenticates with email' do
    post :authenticate, name: users(:testing).email,
                        password: 'password'

    assert_response :success

    token = JSON.parse(@response.body)['token']

    assert_equal users(:testing).id.to_s, Token.authenticate(token)

    Token.delete(token)
  end

  test 'Authentication fails with wrong password' do
    post :authenticate, name: users(:testing).email,
                        password: 'not the password'

    assert_response 401
    assert_equal [1], JSON.parse(@response.body)['errors']
  end

  test 'Authentication returns 400 with malformed request' do
    post :authenticate

    assert_response 400
    assert_equal [2, 3], JSON.parse(@response.body)['errors']
  end

  test 'User logs out correctly' do
    token = Token.generate(users(:testing).id)

    get :logout, token: token

    assert_response :success
    assert_equal nil, Token.authenticate(token)
  end

  test 'Get Authenticated User works correctly' do
    token = Token.generate(users(:testing).id)

    get :get, token: token

    assert_response :success
    assert_equal users(:testing).id,
                 JSON.parse(@response.body)['id']

    Token.delete(token)
  end

  test 'Update user works correctly' do
    token = Token.generate(users(:update_test).id)

    get :update, token: token, email: 'updated@update_test.com',
                 name: 'update_works', password: 'update works'

    assert_response :success
    assert_equal 'updated@update_test.com',
                 User.find_by_id(users(:update_test).id).email
    assert_equal false, User.find_by_id(users(:update_test).id).verified
    assert_equal 'update_works', User.find_by_id(users(:update_test).id).name
    assert User.find_by_id(users(:update_test).id)
      .try(:authenticate, 'update works')

    Token.delete(token)
  end

  test 'Update user returns an error on malformed request' do
    token = Token.generate(users(:update_test).id)

    get :update, token: token, email: 'updatedupdate_test.com'

    assert_response 400
    assert_equal [4], JSON.parse(@response.body)['errors']
    assert_not_equal 'updatedupdate_test.com',
                     User.find_by_id(users(:update_test).id).email

    Token.delete(token)
  end
end
