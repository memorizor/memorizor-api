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

  def require_ownership(model_object)
    @object = model_object.find_by_id(params['id'])
    @user = User.find_by_id(Token.authenticate(params['token']))

    render template: 'not_found', status: 404 if
    @object.nil? || @object.user_id != @user.id
  end

  def authenticated_user
    @user = User.find_by_id(Token.authenticate(params['token']))
  end
end
