class About < ApplicationRecord
  validates :title, :content, presence: true
end
