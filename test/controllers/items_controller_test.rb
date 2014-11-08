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
end
