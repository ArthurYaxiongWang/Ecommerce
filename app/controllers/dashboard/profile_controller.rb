class Dashboard::ProfileController < Dashboard::BaseController

  def password
  end

  def update_password
    if current_user.valid_password?(params[:old_password])
      if current_user.update(user_params)
        bypass_sign_in(current_user) # This is necessary to avoid session expiration after password change
        flash[:notice] = "Successfully updated password"
        redirect_to dashboard_password_path
      else
        render action: :password
      end
    else
      current_user.errors.add :old_password, "Old password is incorrect"
      render action: :password
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
