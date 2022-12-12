class Artist < ApplicationRecord
  has_many :orders

  validates :login, presence: true, uniqueness: true, length: { in: 3..20 }
  validates :nickname, presence: true, uniqueness: false, length: { in: 1..30 }
  validates :password, presence: true, length: { minimum: 8 }

  has_secure_password
end
