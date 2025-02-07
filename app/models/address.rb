class Address < ApplicationRecord
  belongs_to :user
  has_many :checkouts, dependent: :destroy
  validates :first_name, :last_name, :building_name, :street_address, :phone, :country_name, :state_name, :city_name, presence: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
end
