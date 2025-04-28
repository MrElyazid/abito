class Product < ApplicationRecord
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :comments, dependent: :destroy # Add association for comments

  belongs_to :submitted_by, class_name: 'User', optional: true

  has_one_attached :image
end
