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

    def update
      new_amount = params[:shopping_cart][:amount].to_i
      if @shopping_cart.update(amount: new_amount)
        redirect_to shopping_carts_path, notice: 'Shopping cart updated successfully.'
      else
        redirect_to shopping_carts_path, alert: 'Failed to update the shopping cart.'
      end
    end

    def destroy
      @shopping_cart.destroy
      redirect_to shopping_carts_path, notice: 'Item removed from the shopping cart.'
    end

    redirect_to shopping_carts_path
  end

  protected

  def set_shopping_cart
    @shopping_cart = ShoppingCart.find(params[:id])
  end

  def fetch_home_data
    @categories = Category.grouped_data
    @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end
end
