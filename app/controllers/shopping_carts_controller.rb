class ShoppingCartsController < ApplicationController
  before_action :set_cart_item, only: [:update, :destroy]

  def index
    fetch_home_data
    @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid]).includes(cart_items: :product).first
  end

  def create
    amount = params[:amount].to_i
    amount = amount <= 0 ? 1 : amount

    @product = Product.find(params[:product_id])
    @cart_item = ShoppingCart.create_or_update({
      user_uuid: session[:user_uuid],
      user_id: current_user.id,
      product_id: params[:product_id],
      quantity: amount
    })

    if @cart_item.errors.any?
      Rails.logger.info @cart_item.errors.full_messages
    end

    fetch_home_data  # Update the shopping cart count after adding an item
    redirect_to shopping_carts_path
  end

  def update
    new_amount = params[:cart_item][:quantity].to_i
    if @cart_item.update(quantity: new_amount)
      fetch_home_data  # Update the shopping cart count after updating an item
      redirect_to shopping_carts_path, notice: 'Shopping cart updated successfully.'
    else
      redirect_to shopping_carts_path, alert: 'Failed to update the shopping cart.'
    end
  end

  def destroy
    @cart_item.destroy
    fetch_home_data  # Update the shopping cart count after removing an item
    redirect_to shopping_carts_path, notice: 'Item removed from the shopping cart.'
  end

  protected

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def fetch_home_data
    @categories = Category.grouped_data
    if session[:user_uuid].present?
      @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).joins(:cart_items).sum('cart_items.quantity')
    else
      @shopping_cart_count = 0
    end
  end
end
