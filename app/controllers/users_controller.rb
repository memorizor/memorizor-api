class UsersController < ActionController::Base
  include RequireAuthentication
  respond_to :json
  before_filter :require_authentication, :only => [:get, :update, :logour]

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
        return
      end

      @token = Token.generate(@authenticated.id)
    else
      render :authentication_malformed, :status => 400
    end
  end

  def get
    @user = authenticated_user
  end

  def update
    @user = authenticated_user

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

  def logout
    require_authentication or return

    Token.delete params['token']
  end 
end
