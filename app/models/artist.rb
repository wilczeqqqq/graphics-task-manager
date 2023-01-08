class Artist < ApplicationRecord
  has_many :orders

  # COMMON validations
  validates :bio, allow_blank: true, uniqueness: false, length: { in: 1..250 }
  validates :preferred_style, allow_blank: true, uniqueness: false, length: { in: 1..250 }

  # CREATE validations
  validates :login, presence: true, uniqueness: true, length: { in: 3..20 }, on: :create
  validates :nickname, presence: true, uniqueness: false, length: { in: 1..30 }, on: :create
  validates :password, presence: true, uniqueness: false, length: { minimum: 8 }, on: :create

  # UPDATE validations
  validates :login, allow_blank: true, uniqueness: true, length: { in: 3..20 }, on: :update
  validates :nickname, allow_blank: true, uniqueness: false, length: { in: 1..30 }, on: :update
  validates :password, allow_blank: true, uniqueness: false, length: { minimum: 8 }, on: :update

  # PREVENT EMPTY STRING validations
  validates :login, :nickname, :password, :bio, :preferred_style, exclusion: { in: [""] }

  has_secure_password
end
