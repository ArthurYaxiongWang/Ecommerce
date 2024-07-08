class ProductImage < ApplicationRecord
  belongs_to :product
  has_one_attached :image

  validates :weight, presence: true
  validate :correct_image_mime_type
  validate :correct_image_size

  private

  def correct_image_mime_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:image, 'must be a JPEG, PNG, or GIF')
    end
  end

  def correct_image_size
    if image.attached? && image.byte_size > 5.megabytes
      errors.add(:image, 'size must be less than 5MB')
    end
  end
end
