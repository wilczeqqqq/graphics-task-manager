class Client < ApplicationRecord
  has_many :orders
  has_many :address , dependent: :destroy

  # CREATE validations
  validates :full_name, presence: true, uniqueness: false, length: { in: 1..30 }, on: :create
  validates :age, format: { with: /\A(1[3-9]|[2-9][0-9]|100)\z/, message: "Age has to be between 13 and 100" }, on: :create
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Email must have a format: example@mail.com" }, on: :create
  validates :phone, format: { with: /\A\d{9}\z/, message: "Phone number must consists of 9 digits" }, on: :create

  # UPDATE validations
  validates :full_name, allow_blank: true, uniqueness: false, length: { in: 1..30 }, on: :update
  validates :age, allow_blank: true, format: { with: /\A(1[3-9]|[2-9][0-9]|100)\z/, message: "Age has to be between 13 and 100" }, on: :update
  validates :email, allow_blank: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Email must have a format: example@mail.com" }, on: :update
  validates :phone, allow_blank: true, format: { with: /\A\d{9}\z/, message: "Phone number must consists of 9 digits" }, on: :update

  # PREVENT EMPTY STRING validations
  validates :full_name, :email, :phone, exclusion: { in: [""] }

end
