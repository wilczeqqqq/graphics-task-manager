require 'test_helper'

class ServiceApiTest < ActionDispatch::IntegrationTest
  test "should return all services" do
    services = services(:two, :one)

    get "/v1/services"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    # assert_equal services.map(&:attributes).map { |c| c.slice('id', 'name') }, body TODO not working
  end


  test "get service returns one service" do
    service = services(:one)
    category = categories(:one)

    get "/v1/services/#{service.id}"

    assert_equal 200, response.status

    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal service.id, body['id']
    assert_equal service.name, body['name']
    assert_equal service.category.id, body['category']['id']
    assert_equal category.id, body['category']['id']
  end
end
