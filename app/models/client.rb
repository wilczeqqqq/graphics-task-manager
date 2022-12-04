class Client < ApplicationRecord
  has_many :orders
  has_one :address
end
