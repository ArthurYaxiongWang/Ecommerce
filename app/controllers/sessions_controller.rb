class SessionsController < ApplicationController
  def new

  end

  def create
    if user = login(params[:email], params[:password])
      updata_browser_uuid user.uuid

      flash[:notice] = "Signed in successfully."
      redirect_to root_path
    else
      flash.now[:notice] = "Invalid email or password."
      redirect_to new_session_path
    end
  end

  def destroy
    logout
    flash[:notice] = "Signed out successfully."
    redirect_to root_path
  end
end
