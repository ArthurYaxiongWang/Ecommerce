class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_addresses_and_cart, only: [:new, :create]
  protect_from_forgery with: :exception

  def index
    @orders = current_user.orders.includes(order_items: :product)
    Rails.logger.debug "Orders loaded: #{@orders.inspect}"
  end

  def new
    @order = Order.new
    @default_address = current_user.default_address
    calculate_taxes_for_default_address if @default_address
  end

  def create
    Rails.logger.debug "Starting order creation for user: #{current_user.id}"
    shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid]).first

    if shopping_cart.blank?
      Rails.logger.error "No shopping cart found for user_uuid: #{session[:user_uuid]}"
      flash[:alert] = "No shopping cart found"
      redirect_to new_order_path and return
    end

    shopping_cart_items = shopping_cart.cart_items
    Rails.logger.debug "Shopping cart items: #{shopping_cart_items.inspect}"

    if shopping_cart_items.blank?
      Rails.logger.error "No items in shopping cart for user_uuid: #{session[:user_uuid]}"
      flash[:alert] = "No items in shopping cart"
      redirect_to new_order_path and return
    end

    begin
      ActiveRecord::Base.transaction do
        order = current_user.orders.create!(
          address_id: order_params[:address_id],
          total_price: shopping_cart_items.sum { |item| item.product.price * item.quantity },
          amount: shopping_cart_items.sum(:quantity),
          order_no: SecureRandom.hex(10),
          paid_at: Time.now
        )
        Rails.logger.debug "Order created: #{order.inspect}"

        shopping_cart_items.each do |cart_item|
          order_item = order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.quantity,
            total_price: cart_item.product.price * cart_item.quantity
          )
          Rails.logger.debug "Order item created: #{order_item.inspect}"
        end

        shopping_cart_items.destroy_all
        Rails.logger.debug "Shopping cart items after destroy: #{shopping_cart.cart_items.inspect}"
        redirect_to dashboard_orders_path, notice: 'Order was successfully created.'
      end
    rescue => e
      Rails.logger.error "Order creation error: #{e.message}"
      flash[:alert] = "There was an error processing your order: #{e.message}"
      render :new
    end
  end

  private

  def set_addresses_and_cart
    Rails.logger.debug "Session user_uuid: #{session[:user_uuid]}"
    @addresses = current_user.addresses
    @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid]).includes(cart_items: :product).first
    Rails.logger.debug "Shopping cart: #{@shopping_cart.inspect}"
  end

  def order_params
    params.require(:order).permit(:address_id)
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
