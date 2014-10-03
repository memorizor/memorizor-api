require 'test_helper'

class ResetTokenTest < ActiveSupport::TestCase
	test "Generates, uses, and deletes reset token correctly" do
		test_user_id = users(:reset_token).id
		token = ResetToken.generate test_user_id

		assert ResetToken.valid?(token)
		assert_equal ResetToken.owner(token).id, test_user_id

		ResetToken.update_password token, "reset working"

		assert User.find_by_id(test_user_id).try(:authenticate, "reset working")
		assert_not $redis.exists("reset." << token)
	end

	test "Fails with a invalid reset token" do
		token = "invalid token"

		assert_not ResetToken.valid?(token)
		assert_equal ResetToken.owner(token), nil
	end
end
