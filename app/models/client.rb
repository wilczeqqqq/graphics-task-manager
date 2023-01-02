class Client < ApplicationRecord
  has_many :orders
  has_many :address , dependent: :destroy
end
