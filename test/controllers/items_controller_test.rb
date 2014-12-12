require 'json'

class ItemsControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  test 'create works' do
    token = Token.generate users(:verified_user).id
    post :create, token: token, content: 'test', type: 0, answers: ['testing']

    assert_response :success
    assert_equal 'test',
                 Question.find_by_id(JSON.parse(@response.body)['id']).content
    assert_equal 'testing',
                 Question.find_by_id(JSON.parse(@response.body)['id'])
                   .answers[0].content

    Token.delete token
  end

  test 'create fails with nothing included' do
    token = Token.generate users(:verified_user).id
    post :create, token: token

    assert_response 400
    assert_equal [1, 2, 3], JSON.parse(@response.body)['errors']

    Token.delete token
  end

  test 'create fails with invalid type' do
    token = Token.generate users(:verified_user).id
    post :create, token: token, content: 'test', type: 1

    assert_response 400
    assert_equal [3], JSON.parse(@response.body)['errors']

    Token.delete token
  end

  test 'index works' do
    token = Token.generate users(:super_active_user).id
    get :index, token: token, per: 25, page: 2

    assert_response :success
    assert_equal 25, JSON.parse(@response.body).length
    assert_equal 4, @response.headers['TOTAL-PAGES']
    assert_equal 2, @response.headers['CURRENT-PAGE']

    Token.delete token
  end

  # Use Items#show to test require_ownership

  test 'Throws 404 when item does not exist' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: 123_456_789

    assert_response 404
    assert_equal [404], JSON.parse(@response.body)['errors']
  end

  test 'Throws 404 when user is not the owner' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: questions(:nother_test).id

    assert_response 404
    assert_equal [404], JSON.parse(@response.body)['errors']
  end

  test 'Works when user is the owner' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: questions(:test).id

    assert_response :success
    assert_equal questions(:test).id, JSON.parse(@response.body)['id']
  end

  test 'Destroy deletes question and respective answer' do
    token = Token.generate users(:active_user).id

    assert_difference('Question.count', -1) do
      assert_difference('Answer.count', -2) do
        get :destroy, token: token, id: questions(:test).id
      end
    end

    assert_response :success
  end

  test 'update works' do
    token = Token.generate users(:active_user).id
    put :update, token: token, id: questions(:test).id, content: 'updated',
                 type: 0, answers: ['update that']
    assert_response :success
    assert_equal 'updated',
                 Question.find_by_id(JSON.parse(@response.body)['id']).content
    assert_equal 1,
                 Question.find_by_id(JSON.parse(@response.body)['id'])
      .answers.length
    assert_equal 1, JSON.parse(@response.body)['answers'].length
    assert_equal 'update that',
                 Question.find_by_id(JSON.parse(@response.body)['id'])
                   .answers[0].content

    Token.delete token
  end

  test 'update will throw a error when malformed' do
    token = Token.generate users(:active_user).id
    put :update, token: token, id: questions(:test).id, content: 'updated',
                 type: 123, answers: ['update that']
    assert_response 400
    assert_equal [3], JSON.parse(@response.body)['errors']

    Token.delete token
  end
end
