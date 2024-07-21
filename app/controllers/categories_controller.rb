class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.onshelf.page(params[:page] || 1).per(params[:per_page] || 9)
      .order("id desc").includes(:main_product_image)
  end
end
