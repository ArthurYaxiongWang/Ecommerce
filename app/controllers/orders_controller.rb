class OrdersController < ApplicationController
  before_action :authenticate_user

  def new
    fetch_home_data
    @addresses = current_user.addresses
    @shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid)
    .order("id desc").includes(product: [:main_product_image])
  end
  
  def create

  end
end
