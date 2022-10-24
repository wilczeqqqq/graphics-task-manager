class Order < ApplicationRecord
  belongs_to :client
  belongs_to :artist
  belongs_to :service
end
