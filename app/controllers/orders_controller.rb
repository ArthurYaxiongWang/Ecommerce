class OrdersController < ApplicationController
  before_action :authenticate_user
  before_action :set_addresses_and_cart, only: [:new, :create]

  def new
    @order = current_user.orders.new
  end

  def create
    @order = current_user.orders.new(order_params)

    ActiveRecord::Base.transaction do
      if @order.save
        @shopping_cart.cart_items.each do |cart_item|
          @order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.quantity,
            total_price: cart_item.product.price * cart_item.quantity
          )
        end
        @shopping_cart.destroy!
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

  def set_addresses_and_cart
    @addresses = current_user.addresses
    @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid]).includes(cart_items: :product).first
  end

  def order_params
    params.require(:order).permit(:address_id, :total_price, :amount)
  end
end
