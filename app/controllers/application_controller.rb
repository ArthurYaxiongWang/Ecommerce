class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :fetch_home_data
  before_action :set_browser_uuid

  protected

  def authenticate_user
    unless user_signed_in?
      flash[:notice] = "Please sign in first."
      redirect_to new_user_session_path
    end
  end

  def fetch_home_data
    @categories = Category.grouped_data
    if session[:user_uuid].present?
      @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).joins(:cart_items).sum('cart_items.quantity')
    else
      @shopping_cart_count = 0
    end
  end

  def set_browser_uuid
    uuid = cookies[:user_uuid]

    unless uuid
      if user_signed_in?
        uuid = current_user.uuid
      else
        uuid = RandomCode.generate_utoken
      end
    end

    update_browser_uuid(uuid)
  end

  def update_browser_uuid(uuid)
    session[:user_uuid] = cookies.permanent['user_uuid'] = uuid
  end
end
