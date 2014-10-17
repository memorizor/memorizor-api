class UserMailer < ActionMailer::Base
  default from: 'memorizor@memeorizor.com'

  def welcome_email(user)
    @user = user

    mail to: @user.email, from: 'welcome@memorizor.com',
         subject: 'Welcome to Memorizor'
  end

  def verify_email(token, user)
    @user = user
    @token = token

    mail to: @user.email, from: 'verify@memorizor.com',
         subject: '[Memorizor] Please Verify Your Email'
  end

  def reset_email(token, user)
    @user = user
    @token = token

    mail to: @user.email, from: 'reset@memorizor.com',
         subject: '[Memorizor] Password Reset'
  end
end
