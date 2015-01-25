class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

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

  def show
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Profile has been updated."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user
      flash[:error] = "Cannot edit other's profile"
      redirect_to root_path
    end
  end

end