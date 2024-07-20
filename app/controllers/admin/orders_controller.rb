class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.includes(:user, :order_items, :address).all
  end
end
