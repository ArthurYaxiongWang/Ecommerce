class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :fetch_home_data

  before_action :set_browser_uuid

  before_action :set_shopping_cart_count

  protected
  def fetch_home_data
    @categories = Category.grouped_data
    @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end

  def set_browser_uuid
    uuid = cookies[:user_uuid]

    unless uuid
      if logged_in?
        uuid = current_user.uuid
      else
        uuid = RandomCode.generate_utoken
      end
    end

    update_browser_uuid uuid
  end

  def update_browser_uuid uuid
    session[:user_uuid] = cookies.permanent['user_uuid'] = uuid
  end

  def set_shopping_cart_count
    @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end
end
