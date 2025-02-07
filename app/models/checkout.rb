class Checkout < ApplicationRecord
  belongs_to :cart
  belongs_to :address, class_name: 'Address'
  belongs_to :user
end
