class UsersController < ActionController::Base
  respond_to :json

  def create
    @user = User.new(:name => params['name'], :password => params['password'], :email => params['email'])

    if @user.invalid?
      render :status => 400
    else
      @user.save!
    end
  end
end
