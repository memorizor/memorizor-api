module RequireAuthentication
  extend ActiveSupport::Concern

  def require_authentication
    if params.has_key?(:token)
      render(:template => "unauthorized", :status => 401) unless Token.authenticate(params['token'])
    else
      render(:template => "token_required", :status => 400)
    end
  end
end