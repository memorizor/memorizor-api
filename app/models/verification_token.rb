class VerificationToken
  # Token used for verifiing a email address
  require 'securerandom'

  SECONDS_UNTIL_EXPIRATION = 604800 # One week

  def self.generate(user_id)
     token = SecureRandom.urlsafe_base64 30
     $redis.set("verfiy." << token, user_id)
     $redis.expire("verfiy." << token, SECONDS_UNTIL_EXPIRATION)
     return token
  end

  def self.verify(token)
    if $redis.exists("verfiy." << token)
      User.find_by_id($redis.get("verfiy." << token)).update!(:verified => true)
      $redis.del("verfiy." << token)
    end
  end
end