class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :password, :password_confirmation))

    @user.uuid = session[:user_uuid]

    if @user.save
      flash[:notice] = "Signed up successfully! Please sign in."
      redirect_to new_session_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
