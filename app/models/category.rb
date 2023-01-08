class Category < ApplicationRecord
  has_many :services

  # CREATE validations
  validates :name, presence: true, uniqueness: true, length: { in: 1..30 }, on: :create

  # UPDATE validations
  validates :name, allow_blank: true, uniqueness: true, length: { in: 1..30 }, on: :update

  # PREVENT EMPTY STRING validations
  validates :name, exclusion: { in: [""] }

end
