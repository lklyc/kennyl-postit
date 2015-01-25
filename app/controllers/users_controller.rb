class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id # login the user
      flash[:notice] = "Welcome, #{@user.username}! You are now logged in."
      redirect_to root_path
    else
      render :new
    end
  end

  def edit

  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end