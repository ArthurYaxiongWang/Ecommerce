class ShoppingCartsController < ApplicationController
  def index
    fetch_home_data

    @shopping_carts = ShoppingCart.by_user_uuid(session[:user_uuid]).order(id: "desc").includes(:product => [:main_product_image])
  end


end
