class ResetPasswordController < ActionController::Base
  respond_to :json

  def create
    @user = User.find_by(:email => params['email'])
    if not @user.nil?
      @reset_token = ResetToken.generate(@user.id)
      UserMailer.reset_email(@reset_token, @user).deliver
    end
  end

  def valid
    @valid = reset_token_valid
    render(:index_malformed, :status => 400) if @valid.nil?     
  end

  def index
    if reset_token_valid and params.has_key? 'password'
      @user = ResetToken.owner params['reset_token']
      ResetToken.update_password params['reset_token'], params['password']
    else
      render :index_malformed, :status => 400
    end
  end
end

private

def reset_token_valid
    if params.has_key? 'reset_token'
      ResetToken.valid? params['reset_token']
    else
      nil
    end
end