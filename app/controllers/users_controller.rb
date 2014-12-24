class UsersController < ActionController::Base
  include RequireAuthentication
  respond_to :json
  before_action :require_authentication, only: [:get, :update, :logout]

  def create
    @user = User.new name: params['name'], password: params['password'],
                     email: params['email']

    if @user.invalid?
      render :create_malformed, status: 400
    else
      @user.save!
      UserMailer.welcome_email(@user).deliver_now
    end
  end

  def authenticate
    if params.key?('name') && params.key?('password')
      @authenticated = User.find_by(name: params['name'])
                       .try(:authenticate, params['password'])

      unless @authenticated
        @authenticated = User.find_by(email: params['name'])
                         .try(:authenticate, params['password'])
      end

      unless @authenticated
        render :authentication_failed, status: 401
        return
      end

      @token = Token.generate(@authenticated.id)
    else
      render :authentication_malformed, status: 400
    end
  end

  def get
    @user = authenticated_user
  end

  def update
    @user = authenticated_user

    @user.name = params['name'] if params.key? 'name'

    if params.key? 'email'
      @user.email = params['email']
      @user.verified = false
    end

    @user.password = params['password'] if params.key? 'password'

    if @user.invalid?
      render :create_malformed, status: 400
    else
      @user.save!
    end
  end

  def logout
    Token.delete params['token']
  end
end
