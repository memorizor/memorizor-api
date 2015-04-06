require 'json'

class ReviewsControllerTest < ActionController::TestCase
  def setup
    @request.headers['Accept'] = 'application/json'
  end

  test 'index works' do
    token = Token.generate users(:super_active_user).id
    get :index, token: token, per: 25, page: 2

    assert_response :success
    assert_equal 25, JSON.parse(@response.body).length
    assert_equal 2, @response.headers['TOTAL-PAGES']
    assert_equal 2, @response.headers['CURRENT-PAGE']

    Token.delete token
  end

  test 'throws 404 when the question is not reviewable' do
    token = Token.generate users(:active_user).id
    get :update, token: token,
                 id: questions(:a_hitchhikers_guide_to_the_galaxy).id,
                 correct: true

    assert_response 404

    Token.delete token
  end

  test 'throws exception when correct is not present' do
    token = Token.generate users(:review_user).id
    get :update, token: token, id: questions(:low_level).id

    assert_response 401
    assert_equal [1], JSON.parse(@response.body)['errors']

    Token.delete token
  end

  test 'update correct works' do
    token = Token.generate users(:review_user).id
    get :update, token: token, id: questions(:low_level).id, correct: true

    assert_response :success
    assert_equal 3, JSON.parse(@response.body)['level']

    review_time=Time.zone.parse(JSON.parse(@response.body)['review_at'])
    expected_time = 12.hours.from_now
    assert_equal review_time.hour, expected_time.hour
    assert_equal review_time.month, expected_time.month
    assert_equal review_time.year, expected_time.year

    Token.delete token
  end

  test 'update incorrect works' do
    token = Token.generate users(:review_user).id
    get :update, token: token, id: questions(:max_level).id, correct: false

    assert_response :success
    assert_equal 16, JSON.parse(@response.body)['level']

    review_time=Time.zone.parse(JSON.parse(@response.body)['review_at'])
    expected_time = 730.hours.from_now
    assert_equal review_time.hour, expected_time.hour
    assert_equal review_time.month, expected_time.month
    assert_equal review_time.year, expected_time.year

    Token.delete token
  end
end
