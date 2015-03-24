require 'json'

class CatagoriesControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  test 'index works' do
    token = Token.generate users(:super_active_user).id
    get :index, token: token, per: 25, page: 2, items_max: 2

    assert_response :success
    assert_equal 25, JSON.parse(@response.body).length

    JSON.parse(@response.body).each do |catagory|
      assert_equal 2, catagory['items'].length
    end

    assert_equal 2, @response.headers['TOTAL-PAGES']
    assert_equal 2, @response.headers['CURRENT-PAGE']

    Token.delete token
  end

  test 'Create works' do
    token = Token.generate users(:verified_user).id
    post :create, token: token, name: 'it works', color: 'ffffff',
                  questions: [questions(:nother_test).id]

    assert_response :success
    assert_equal 'it works',
                 Catagory.find_by_id(JSON.parse(@response.body)['id']).name
    assert_equal questions(:nother_test),
                 Catagory.find_by_id(JSON.parse(@response.body)['id'])
                   .questions[0]

    Token.delete token
  end

  test 'Create throws errors with nothing included' do
    token = Token.generate users(:verified_user).id
    post :create, token: token

    assert_response 400
    assert_equal [1, 2], JSON.parse(@response.body)['errors']
    Token.delete token
  end

  test 'Create throws errors with invalid color' do
    token = Token.generate users(:verified_user).id
    post :create, token: token, name: 'this is a name', color: 'not a color!'

    assert_response 400
    assert_equal [3], JSON.parse(@response.body)['errors']
    Token.delete token
  end

  test 'Update Works' do
    token = Token.generate users(:verified_user).id
    post :update, token: token, id: catagories(:other_catagory),
                  name: 'update works', color: '000000',
                  questions: [questions(:nother_test).id]

    assert_response :success
    assert_equal 'update works',
                 Catagory.find_by_id(JSON.parse(@response.body)['id']).name
    assert_equal '000000',
                 Catagory.find_by_id(JSON.parse(@response.body)['id']).color
    assert_equal questions(:nother_test),
                 Catagory.find_by_id(JSON.parse(@response.body)['id'])
                   .questions[0]

    Token.delete token
  end

  # Use Catagories#show to test require_ownership

  test 'Throws 404 when catagory does not exist' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: 123_456_789

    assert_response 404
    assert_equal [404], JSON.parse(@response.body)['errors']
  end

  test 'Throws 404 when user is not the owner' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: catagories(:other_catagory).id

    assert_response 404
    assert_equal [404], JSON.parse(@response.body)['errors']
  end

  test 'Works when user is the owner' do
    token = Token.generate users(:active_user).id
    get :show, token: token, id: catagories(:test_catagory).id

    assert_response :success
    assert_equal catagories(:test_catagory).id, JSON.parse(@response.body)['id']
  end

  test 'Destroy deletes question and respective answer' do
    token = Token.generate users(:active_user).id

    assert_difference('Catagory.count', -1) do
      get :destroy, token: token, id: catagories(:test_catagory).id
    end

    assert_response :success
  end
end
