class ShoppingCartsController < ApplicationController
  def index
    fetch_home_data
    @shopping_carts = ShoppingCart.by_user_uuid(session[:user_uuid]).includes(:product).order(id: :desc)
  end

  def create
    amount = params[:amount].to_i
    amount = amount <= 0 ? 1 : amount

    @product = Product.find(params[:product_id])
    @shopping_cart = ShoppingCart.create_or_update({
      user_uuid: session[:user_uuid],
      product_id: params[:product_id],
      amount: amount
    })

    if @shopping_cart.errors.any?
      Rails.logger.info @shopping_cart.errors.full_messages
    end

    redirect_to shopping_carts_path
  end

  protected

  def fetch_home_data
    @categories = Category.grouped_data
    @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end
end
