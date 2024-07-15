class ProductsController < ApplicationController
  before_action :fetch_home_data

  def index
    @products = Product.page(params[:page]).per(9)
  end

  def show
    @product = Product.find(params[:id])
  end

  def search
    @products = Product.where("title like :title", title: "%#{params[:w]}%")
    .order("id desc").page(params[:page] || 1).per(params[:per_page] || 9)
    .includes(:main_product_image)

    unless params[:category_id].blank?
      @products = @products.where(category_id: params[:category_id])
    end

    render 'welcome/index'
  end
end
