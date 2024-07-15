class OrdersController < ApplicationController
  before_action :authenticate_user

  def new
    fetch_home_data
    @addresses = current_user.addresses
    @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid]).includes(cart_items: :product).first
  end

  def create
    @order = current_user.orders.new(order_params)
    shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid)

    ActiveRecord::Base.transaction do
      if @order.save
        shopping_carts.each do |cart_item|
          @order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.amount,
            total_price: cart_item.product.price * cart_item.amount
          )
        end
        shopping_carts.destroy_all
        redirect_to @order, notice: 'Order was successfully created.'
      else
        render :new
      end
    end
  rescue => e
    flash[:alert] = "There was an error processing your order: #{e.message}"
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:address_id, :total_price, :amount)
  end
end
