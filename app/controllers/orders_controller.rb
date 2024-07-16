class OrdersController < ApplicationController
  before_action :authenticate_user
  before_action :set_addresses_and_cart, only: [:new, :create]

  def new
    @order = Order.new
    @default_address = current_user.default_address
    calculate_taxes_for_default_address if @default_address
  end

  def create
    @order = current_user.orders.new(order_params)
    shopping_carts = ShoppingCart.by_user_uuid(session[:user_uuid])

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

  def set_addresses_and_cart
    @addresses = current_user.addresses
    @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid]).includes(cart_items: :product).first
  end

  def order_params
    params.require(:order).permit(:address_id, :total_price)
  end

  def calculate_taxes_for_default_address
    total_price = @shopping_cart.total_price
    province_name = @default_address.province.name
    taxes = calculate_taxes(total_price, province_name)
    @total_price_with_taxes = total_price + taxes[:pst] + taxes[:gst] + taxes[:hst]
    @pst = taxes[:pst]
    @gst = taxes[:gst]
    @hst = taxes[:hst]
  end

  def calculate_taxes(total_price, province_name)
    rates = tax_rates[province_name]
    pst = total_price * rates[:pst]
    gst = total_price * rates[:gst]
    hst = total_price * rates[:hst]

    { pst: pst, gst: gst, hst: hst }
  end

  def tax_rates
    {
      'Alberta' => { pst: 0.0, gst: 0.05, hst: 0.0 },
      'British Columbia' => { pst: 0.07, gst: 0.05, hst: 0.0 },
      'Manitoba' => { pst: 0.07, gst: 0.05, hst: 0.0 },
      'New Brunswick' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Newfoundland and Labrador' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Nova Scotia' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Ontario' => { pst: 0.0, gst: 0.0, hst: 0.13 },
      'Prince Edward Island' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Quebec' => { pst: 0.09975, gst: 0.05, hst: 0.0 },
      'Saskatchewan' => { pst: 0.06, gst: 0.05, hst: 0.0 },
      'Northwest Territories' => { pst: 0.0, gst: 0.05, hst: 0.0 },
      'Nunavut' => { pst: 0.0, gst: 0.05, hst: 0.0 },
      'Yukon' => { pst: 0.0, gst: 0.05, hst: 0.0 }
    }
  end
end
