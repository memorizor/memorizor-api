require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'Should not save a User without a name' do
    user = User.new email: 'test@test.com', password: 'foo'
    user.valid?
    assert user.errors['name'].include? "can't be blank"
  end

  test 'Should not save a User without a email' do
    user = User.new name: 'bar', password: 'foo'
    user.valid?
    assert user.errors['email'].include? "can't be blank"
  end

  test 'Should not save a User without a password' do
    user = User.new name: 'bar', email: 'test@test.com'
    user.valid?
    assert user.errors['password'].include? "can't be blank"
  end

  test 'Should not save a User with a invalid email (no domain)' do
    user = User.new name: 'bar', email: 'test@', password: 'foo'
    user.valid?
    assert user.errors['email'].include? 'is not an email'
  end

  test 'Should not save a User with a invalid email (no TLD)' do
    user = User.new name: 'bar', email: 'test@test', password: 'foo'
    user.valid?
    assert user.errors['email'].include? 'is not an email'
  end

  test 'Should not save a User with a invalid email (no @ sign)' do
    user = User.new name: 'bar', email: 'testtest.com', password: 'foo'
    user.valid?
    assert user.errors['email'].include? 'is not an email'
  end

  test 'Should not save a User with a non-unique email' do
    user = User.new name: 'bar', email: 'test@fixture.com', password: 'foo'
    user.valid?
    assert user.errors['email'].include? 'has already been taken'
  end

  test 'Should not save a User with a non-unique name' do
    user = User.new name: 'test', email: 'test@test.com', password: 'foo'
    user.valid?
    assert user.errors['name'].include? 'has already been taken'
  end

  test 'Should correctly list reviews' do
    assert_equal 1, users(:active_user).reviews.length
    assert_equal questions(:test).id,
                 users(:active_user).reviews[0].id
  end
end
