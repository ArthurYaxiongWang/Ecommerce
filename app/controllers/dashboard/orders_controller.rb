class Dashboard::OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    @orders = current_user.orders
                          .includes(order_items: { product: :main_product_image })
                          .order(id: :desc)
                          .page(params[:page] || 1)
                          .per(params[:per_page] || 10)
  end

  def destroy
    @order = current_user.orders.find(params[:id])
    @order.destroy
    redirect_to dashboard_orders_path, notice: 'Order was successfully deleted.'
  end
end
