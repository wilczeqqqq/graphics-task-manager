class Address < ApplicationRecord
  belongs_to :client

  # CREATE validations
  validates :address_line_1, presence: true, length: { in: 1..50 }, on: :create
  validates :address_line_2, allow_blank: true, length: { in: 1..50 }, on: :create
  validates :city, presence: true, length: { in: 1..50 }, on: :create
  validates :postal_code, format: { with: /\A\d{2}-?\d{3}\z/, message: "Postal code must be in '12345' or '12-345' format" }, on: :create
  validates :country, format: { with: /\A[A-Z]{2}\z/, message: "Country must be in exactly two uppercase letters format" }, on: :create

  # UPDATE validations
  validates :address_line_1, allow_blank: true, length: { in: 1..50 }, on: :update
  validates :address_line_2, allow_blank: true, length: { in: 1..50 }, on: :update
  validates :city, allow_blank: true, length: { in: 1..50 }, on: :update
  validates :postal_code, allow_blank: true, format: { with: /\A\d{2}-?\d{3}\z/, message: "Postal code must be in '12345' or '12-345' format" }, on: :update
  validates :country, allow_blank: true, format: { with: /\A[A-Z]{2}\z/, message: "Country must be in exactly two uppercase letters format" }, on: :update

  # PREVENT EMPTY STRING validations
  validates :address_line_1, :address_line_2, :city, :country, :postal_code, exclusion: { in: [""] }

end
