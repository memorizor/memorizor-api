class VerifiesController < ActionController::Base
  include RequireAuthentication
  respond_to :json

  def create
    require_authentication
    @user = User.find_by_id(Token.authenticate(params['token']))
    if @user.verified
      render :already_verified
    else 
      @verification_token = VerificationToken.generate(Token.authenticate(params['token']))
      UserMailer.verify_email(@verification_token, @user).deliver
    end
  end

  def show
    if params.has_key? 'verification_token'
      VerificationToken.verify params['verification_token']
    else
      render :show_malformed, :status => 400
    end
  end
end