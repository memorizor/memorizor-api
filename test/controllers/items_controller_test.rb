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
    token = Token.generate users(:active_user).id
    get :index, token: token

    assert_response :success
    assert_equal '[{"id":411008527,"review_at":"2000-01-01T01:00:00.000Z",'\
                 '"type":0,"content":"Is this a test?","answers":["It is.",'\
                 '"Why are asking me?"]},{"id":926490937,'\
                 '"review_at":"2000-01-01T01:00:00.000Z","type":0,'\
                 '"content":"What is the meaning of life,'\
                 ' the universe and everything?","answers":["42"]}]',
                 @response.body
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
    assert_equal 'update that',
                 Question.find_by_id(JSON.parse(@response.body)['id'])
      .answers[0].content

    Token.delete token
  end
end
