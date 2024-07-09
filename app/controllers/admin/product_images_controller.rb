class Admin::ProductImagesController < Admin::BaseController

  before_action :find_product

  def index
    @product_images = @product.product_images
  end

  def create
    params[:images].each do |image|
      @product.product_images << ProductImage.new(image: image)
    end

    redirect_back(fallback_location: admin_product_product_images_path(@product))
  end

  def destroy
    @product_image = @product.product_images.find(params[:id])
    if @product_image.destroy
      flash[:notice] = "Successfully deleted"
    else
      flash[:notice] = "Failed to delete"
    end

    redirect_back(fallback_location: admin_product_product_images_path(@product))
  end

  def update
    @product_image = @product.product_images.find(params[:id])
    @product_image.weight = params[:weight]
    if @product_image.save
      flash[:notice] = "Successfully updated"
    else
      flash[:notice] = "Failed to update"
    end

    redirect_back(fallback_location: admin_product_product_images_path(@product))
  end

  private
  def find_product
    @product = Product.find params[:product_id]
  end

end
