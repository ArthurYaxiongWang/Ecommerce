class Dashboard::OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    @orders = current_user.orders.page(params[:page] || 1).per(params[:per_page] || 10)
      .includes([[:product => [:main_product_image]], :address]).order("id desc")
  end
end
