class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    super do |resource|
      if resource.errors.any?
        Rails.logger.info "User creation failed: #{resource.errors.full_messages.join(', ')}"
        flash[:error] = resource.errors.full_messages.join(', ')
      end
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :address, :province_id])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :address, :province_id])
  end
end
