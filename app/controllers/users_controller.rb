class UsersController < ActionController::Base
  include RequireAuthentication
  respond_to :json

  def create
    @user = User.new(:name => params['name'], :password => params['password'], :email => params['email'])

    if @user.invalid?
      render :create_malformed, :status => 400
    else
      @user.save!
      UserMailer.welcome_email(@user).deliver
    end
  end

  def authenticate
    if params.has_key?(:name) and params.has_key?(:password)
      @authenticated = User.find_by(:name => params['name']).try(:authenticate, params['password'])

      if not @authenticated
        @authenticated = User.find_by(:email => params['name']).try(:authenticate, params['password'])
      end

      if not @authenticated
        render :authentication_failed, :status => 401
      end

      @token = Token.generate(@authenticated.id)
    else
      render :authentication_malformed, :status => 400
    end
  end

  def get
    require_authentication

    @user = User.find_by_id(Token.authenticate(params['token']))
  end

  def update
    require_authentication

    @user = User.find_by_id(Token.authenticate(params['token']))

    if params.has_key?(:name)
      @user.name = params[:name]
    end

    if params.has_key?(:email)
      @user.email = params[:email]
      @user.verified = false
    end

    if params.has_key?(:password)
      @user.password = params[:password]
    end

    if @user.invalid?
      render :create_malformed, :status => 400
    else
      @user.save!
    end
  end
end
