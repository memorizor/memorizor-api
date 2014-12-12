class Token
  # Token used for authentication with memorizor
  require 'securerandom'

  SECONDS_UNTIL_EXPIRATION = 604_800 # One week

  def self.generate(user_id)
    token = SecureRandom.urlsafe_base64 30
    $redis.set('token.' << token, user_id)
    $redis.expire('token.' << token, SECONDS_UNTIL_EXPIRATION)
    token
  end

  def self.delete(token)
    $redis.del('token.' << token)
  end

  def self.authenticate(token)
    if $redis.exists('token.' << token)
      $redis.expire('token.' << token, SECONDS_UNTIL_EXPIRATION)
      $redis.get('token.' << token)
    end
  end
end
