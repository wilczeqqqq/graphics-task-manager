class Service < ApplicationRecord
  belongs_to :category
  has_many :orders

  # CREATE validations
  validates :name, presence: true, uniqueness: true, length: { in: 1..100 }, on: :create

  # UPDATE validations
  validates :name, allow_blank: true, uniqueness: true, length: { in: 1..100 }, on: :update

  # PREVENT EMPTY STRING validations
  validates :name, exclusion: { in: [""] }

end
