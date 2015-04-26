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
         subject: '[Memorizor] Reset Your Password'
  end

  def payment_failed(user)
    @user = user

    mail to: @user.email, from: 'billing@memorizor.com',
         subject: '[Memorizor] Urgent: Monthly Payment Failed'
  end

  def payment_succeeded(user, invoice)
    @user = user
    @invoice = invoice

    mail to: @user.email, from: 'billing@memorizor.com',
         subject: '[Memorizor] Monthly Invoice'
  end

  def registered_plan(user, invoice)
    @user = user
    @invoice = invoice

    mail to: @user.email, from: 'billing@memorizor.com',
         subject: "[Memorizor] Registered for #{@invoice['plan']['name']}"
  end

  def subscription_cancelled(user)
    @user = user

    mail to: @user.email, from: 'billing@memorizor.com',
         subject: '[Memorizor] Subscription Cancelled'
  end
end
