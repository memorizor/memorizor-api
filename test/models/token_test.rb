require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  test 'Generates, uses, and deletes token correctly' do
    test_user_id = '0'
    token = Token.generate(test_user_id)

    assert_equal Token.authenticate(token), test_user_id

    Token.delete(token)

    assert_equal Token.authenticate(token), nil
  end

  test 'Fails with an invalid token' do
    token = 'invalid token'

    assert_equal Token.authenticate(token), nil
  end
end
