require 'test_helper'

class VerificationTokenTest < ActiveSupport::TestCase
	test "Generates, uses, and deletes verification token correctly" do
		test_user_id = users(:verification_token).id
		token = VerificationToken.generate test_user_id
		VerificationToken.verify token

		assert_equal User.find_by_id(test_user_id).verified, true
		assert_not $redis.exists("verify." << token)
	end
end
