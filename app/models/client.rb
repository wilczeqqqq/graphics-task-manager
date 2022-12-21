class Client < ApplicationRecord
  has_many :orders
  has_many :address
end
