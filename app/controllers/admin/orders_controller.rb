class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.includes(:user, :order_items => :product).order(created_at: :desc)
  end
end
