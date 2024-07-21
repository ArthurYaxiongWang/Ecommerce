class ProductImage < ApplicationRecord
  belongs_to :product

  has_one_attached :image

  validate :image_content_type
  validate :image_size

  def small_image
    image.variant(resize_to_fill: [60, 60]).processed
  end

  def medium_image
    image.variant(resize_to_fill: [200, 200]).processed
  end

  def large_image
    image.variant(resize_to_limit: [500, nil]).processed
  end

  private

  def image_content_type
    if image.attached? && !image.content_type.in?(%w(image/jpeg image/png image/gif))
      errors.add(:image, 'must be a JPEG, PNG, or GIF')
    end
  end

  def image_size
    if image.attached? && image.byte_size > 5.megabytes
      errors.add(:image, 'size must be less than 5MB')
    end
  end
end
