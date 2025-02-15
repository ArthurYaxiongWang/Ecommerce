class WelcomeController < ApplicationController
  def index
    fetch_home_data

    @products = Product.onshelf.page(params[:page] || 1).per(params[:per_page] || 9).order("id desc").includes(:main_product_image)

    @about = About.first
    @contact = Contact.first
  end
end
