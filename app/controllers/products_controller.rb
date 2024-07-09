class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(9)
  end

  def show
    fetch_home_data

    @product = Product.find(params[:id])
  end
end
