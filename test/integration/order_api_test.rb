require 'test_helper'

class OrderApiTest < ActionDispatch::IntegrationTest
  test "should return all orders" do
    orders = orders(:two, :one)
    clients = clients(:two, :one)
    artist = artists(:two, :one)
    services = services(:two, :one)

    get "/v1/orders"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    assert_equal orders[0].id, body[0]['id']
    assert_equal orders[1].id, body[1]['id']

    assert_equal orders[0].client.id, body[0]['client']['id']
    assert_equal clients[0].id, body[0]['client']['id']
    assert_equal orders[1].client.id, body[1]['client']['id']
    assert_equal clients[1].id, body[1]['client']['id']

    assert_equal orders[0].artist.id, body[0]['artist']['id']
    assert_equal artist[0].id, body[0]['artist']['id']
    assert_equal orders[1].artist.id, body[1]['artist']['id']
    assert_equal artist[1].id, body[1]['artist']['id']

    assert_equal orders[0].service.id, body[0]['service']['id']
    assert_equal services[0].id, body[0]['service']['id']
    assert_equal orders[1].service.id, body[1]['service']['id']
    assert_equal services[1].id, body[1]['service']['id']
  end


  test "get service returns one order" do
    order = orders(:one)
    client = clients(:one)
    artist = artists(:one)
    service = services(:one)

    get "/v1/orders/#{order.id}"

    assert_equal 200, response.status

    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal order.id, body['id']

    assert_equal order.client.id, body['client']['id']
    assert_equal client.id, body['client']['id']

    assert_equal order.artist.id, body['artist']['id']
    assert_equal artist.id, body['artist']['id']

    assert_equal order.service.id, body['service']['id']
    assert_equal service.id, body['service']['id']
  end

  test "should create an order" do
    client = clients(:one)
    artist = artists(:one)
    service = services(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/orders/", params: { notes: "Test order", client_id: "#{client.id}", artist_id: "#{artist.id}", service_id: "#{service.id}" }, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    assert_instance_of Hash, create_body
    assert_equal "Test order", create_body['notes']
    assert_equal client.id, create_body['client']['id']
    assert_equal artist.id, create_body['artist']['id']
    assert_equal service.id, create_body['service']['id']

    get "/v1/orders/#{create_body['id']}"
    assert_equal 200, response.status
  end

  test "should update an order" do
    order = orders(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    patch "/v1/orders/#{order.id}", params: { order_status: "COMPLETED" }, headers: headers
    assert_equal 200, response.status
    update_body = JSON.parse(response.body)

    assert_instance_of Hash, update_body
    assert_equal "COMPLETED", update_body['order_status']

    get "/v1/orders/#{order.id}"
    get_body = JSON.parse(response.body)

    assert_equal update_body['order_status'], get_body['order_status']
  end

  test "should destroy an order" do
    order = orders(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    delete "/v1/orders/#{order.id}", headers: headers
    assert_equal 200, response.status
    delete_body = JSON.parse(response.body)

    assert_instance_of Hash, delete_body
    assert_equal "true", delete_body['success']
  end
end
