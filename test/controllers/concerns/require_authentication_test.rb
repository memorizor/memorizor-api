class RequireAuthenticationTest < ActionController::TestCase

  # Use user#get to test RequireAuthentication concern
  test "Throws token required" do
    @controller = UsersController.new
    get :get

    assert_response 400
  end

  test "Throws token invalid" do
    @controller = UsersController.new
    get :get, {:token => 'invalid token'}

    assert_response 401
  end
end
