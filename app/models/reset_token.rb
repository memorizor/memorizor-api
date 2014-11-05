class ResetToken
  # Token used for verifiing a email address
  require 'securerandom'

  SECONDS_UNTIL_EXPIRATION = 604_800 # One week

  def self.generate(user_id)
    token = SecureRandom.urlsafe_base64 30
    $redis.set('reset.' << token, user_id)
    $redis.expire('reset.' << token, SECONDS_UNTIL_EXPIRATION)
    token
  end

  def self.valid?(token)
    $redis.exists('reset.' << token)
  end

  def self.owner(token)
    if $redis.exists('reset.' << token)
      User.find_by_id($redis.get('reset.' << token))
    end
  end

  def self.update_password(token, password)
    if $redis.exists('reset.' << token)
      User.find_by_id($redis.get('reset.' << token))
        .update!(password: password)
      $redis.del('reset.' << token)
    end
  end
end
