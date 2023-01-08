class Order < ApplicationRecord
  belongs_to :client
  belongs_to :artist
  belongs_to :service

  # COMMON validations
  validates :notes, allow_blank: true, uniqueness: false, length: { in: 1..250 }

  # UPDATE validations
  validates :order_status, allow_blank: true, uniqueness: false, format: { with: /\ACREATED|IN_PROGRESS|COMPLETED|CANCELLED\z/, message: "Status must be: CREATED, IN_PROGRESS, COMPLETED, CANCELLED" }, on: :update

  # PREVENT EMPTY STRING validations
  validates :order_status, :notes, exclusion: { in: [""] }

end
