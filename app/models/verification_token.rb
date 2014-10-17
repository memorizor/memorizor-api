class VerificationToken
  # Token used for verifiing a email address
  require 'securerandom'

  SECONDS_UNTIL_EXPIRATION = 604_800 # One week

  def self.generate(user_id)
    token = SecureRandom.urlsafe_base64 30
    $redis.set('verify.' << token, user_id)
    $redis.expire('verify.' << token, SECONDS_UNTIL_EXPIRATION)
    token
  end

  def self.verify(token)
    if $redis.exists('verify.' << token)
      User.find_by_id($redis.get('verify.' << token)).update!(verified: true)
      $redis.del('verify.' << token)
    end
  end
end
