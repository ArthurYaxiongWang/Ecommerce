class OrdersController < ApplicationController
  before_action :authenticate_user

  def new
    fetch_home_data
  end

  def create

  end
end
