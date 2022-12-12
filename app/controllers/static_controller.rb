class StaticController < ApplicationController
  def index
    @clients = Client.all
    @artists = Artist.all
    @orders = Order.all
    @services = Service.all
    @categories = Category.all
    @addresses = Address.all
  end
end
