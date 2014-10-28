module RequireAuthentication
  extend ActiveSupport::Concern

  def require_authentication
    if params.key?(:token)
      unless Token.authenticate params['token']
        render template: 'unauthorized', status: 401
      end
    else
      render template: 'token_required', status: 400
    end
  end

  def require_verification
    render template: 'verification_required', status: 403 unless
      authenticated_user.verified
  end

  def authenticated_user
    @user = User.find_by_id(Token.authenticate(params['token']))
  end
end
