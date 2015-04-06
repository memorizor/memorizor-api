require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test 'Level up works properly' do
    @question = questions(:low_level)

    @question.correct

    assert_equal @question.level, 3

    review_time = @question.review_at
    expected_time = 12.hours.from_now
    assert_equal review_time.hour, expected_time.hour
    assert_equal review_time.month, expected_time.month
    assert_equal review_time.year, expected_time.year
  end

  test 'Level down works properly' do
    @question = questions(:max_level)

    @question.incorrect

    assert_equal @question.level, 16

    review_time = @question.review_at
    expected_time = 730.hours.from_now
    assert_equal review_time.hour, expected_time.hour
    assert_equal review_time.month, expected_time.month
    assert_equal review_time.year, expected_time.year
  end

  test 'Level up does not go past 21' do
    @question = questions(:max_level)

    @question.correct

    assert_equal @question.level, 19

    review_time = @question.review_at
    expected_time = 4383.hours.from_now
    assert_equal review_time.hour, expected_time.hour
    assert_equal review_time.month, expected_time.month
    assert_equal review_time.year, expected_time.year
  end

  test 'Level down does not go past 0' do
    @question = questions(:low_level)

    @question.incorrect

    assert_equal @question.level, 0

    review_time = @question.review_at
    expected_time = 6.hours.from_now
    assert_equal review_time.hour, expected_time.hour
    assert_equal review_time.month, expected_time.month
    assert_equal review_time.year, expected_time.year
  end

  test 'is reviewable returns true' do
    assert_equal true, questions(:test).reviewable?
  end

  test 'is reviewable returns false' do
    assert_equal questions(:a_hitchhikers_guide_to_the_galaxy).reviewable?, false
  end
end
