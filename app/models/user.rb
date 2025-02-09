class User < ApplicationRecord
  has_secure_password
  has_one :cart, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :checkouts, dependent: :destroy # Add this line
  
  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 6 }

  def ensure_cart!
    cart || create_cart!
  end
end
