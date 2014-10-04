require 'json'

class UsersControllerTest < ActionController::TestCase
  def setup
    @request.headers["Accept"] = "application/json"
  end

  test "Properly creates a user" do
    assert_difference('User.count', 1) do
      post :create, {:name => "create_test", :email => "create_test@testing.com", :password => "super secure"}
    end

    assert_response :success
  end

  test "Returns a 400 with invalid request" do
    post :create, {:name => "create_test", :email => "create_test@testing.com"}

    assert_response 400
  end

  test "Authenticates with username" do
    post :authenticate, {:name => users(:authentication_test).name, :password => "password"}

    assert_response :success

    token = JSON.parse(@response.body)['token']

    assert_equal users(:authentication_test).id.to_s, Token.authenticate(token)

    Token.delete(token)
  end

  test "Authenticates with email" do
    post :authenticate, {:name => users(:authentication_test).email, :password => "password"}

    assert_response :success

    token = JSON.parse(@response.body)['token']

    assert_equal users(:authentication_test).id.to_s, Token.authenticate(token)

    Token.delete(token)
  end

  test "Authentication fails with wrong password" do
    post :authenticate, {:name => users(:authentication_test).email, :password => "not the password"}

    assert_response 401
  end

  test "Authentication returns 400 with malformed request" do
    post :authenticate, {:name => users(:authentication_test).email}

    assert_response 400
  end

  test "User logs out correctly" do
    token = Token.generate(users(:authentication_test).id)

    get :logout, {:token => token}

    assert_response :success
    assert_equal nil, Token.authenticate(token)
  end

  test "Get Authenticated User works correctly" do
    token = Token.generate(users(:authentication_test).id)

    get :get, {:token => token}

    assert_response :success
    assert_equal users(:authentication_test).id, JSON.parse(@response.body)['id']

    Token.delete(token)
  end

  test "Update user works correctly" do
    token = Token.generate(users(:update_test).id)

    get :update, {:token => token, :email => "updated@update_test.com", :name => "update_works", :password => "update works"}

    assert_response :success
    assert_equal "updated@update_test.com", User.find_by_id(users(:update_test).id).email
    assert_equal false, User.find_by_id(users(:update_test).id).verified
    assert_equal "update_works",User.find_by_id(users(:update_test).id).name
    assert User.find_by_id(users(:update_test).id).try(:authenticate, "update works")

    Token.delete(token)
  end
end
