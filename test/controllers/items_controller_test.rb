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
  end

  test 'create fails with nothing included' do
    token = Token.generate users(:verified_user).id
    post :create, token: token

    assert_response 400
    assert_equal [1, 2, 3], JSON.parse(@response.body)['errors']
  end

  test 'create fails with invalid type' do
    token = Token.generate users(:verified_user).id
    post :create, token: token, content: 'test', type: 1

    assert_response 400
    assert_equal [3], JSON.parse(@response.body)['errors']
  end
end
