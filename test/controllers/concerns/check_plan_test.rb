require 'json'

class CheckPlanTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  # Use Items controller to test check_plan
  test 'Throws error with plan breaking user' do
    token = Token.generate users(:plan_breaking_user).id
    @controller = ItemsController.new
    get :update, token: token, id: questions(:much_question_1).id

    assert_response 403

    Token.delete(token)
  end

  test 'Throws error with plan max user' do
    token = Token.generate users(:plan_max_user).id
    @controller = ItemsController.new
    get :create, token: token

    assert_response 403

    Token.delete(token)
  end
end
