class Token
  # Token used for authentication with memorizor
  require 'securerandom'

  SECONDS_UNTIL_EXPIRATION = 604800 # One week

  def self.generate(user_id)
     token = SecureRandom.urlsafe_base64 30
     $redis.set("token." << token, user_id)
     $redis.expire("token." << token, SECONDS_UNTIL_EXPIRATION)
     return token
  end

  def self.remove(token)
    $redis.del("token." << token)
  end

  def self.authenticate(token)
    if $redis.exists("token." << token)
      $redis.expire("token." << token, SECONDS_UNTIL_EXPIRATION)
      $redis.get("token." << token)
    else
      nil
    end
  end
end