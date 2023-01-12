require 'test_helper'

class ClientApiTest < ActionDispatch::IntegrationTest
  test "should return all clients" do
    clients = clients(:two, :one)

    get "/v1/clients"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    assert_equal clients.map(&:attributes).map { |c| c.slice('id', 'full_name', 'email', 'phone', 'age') }, body
  end

  test "should return one client" do
    client = clients(:one)

    get "/v1/clients/#{client.id}"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal client.id, body['id']
    assert_equal client.full_name, body['full_name']
    assert_equal client.email, body['email']
    assert_equal client.phone, body['phone']
    assert_equal client.age, body['age']
  end

  test "should create a client" do
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/clients/", params: { full_name: "Test client", email: "test.client@email.com", phone: "999999999", age: 99 }, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    assert_instance_of Hash, create_body
    assert_equal "Test client", create_body['full_name']
    assert_equal "test.client@email.com", create_body['email']
    assert_equal "999999999", create_body['phone']
    assert_equal 99, create_body['age']

    get "/v1/clients/#{create_body['id']}"
    assert_equal 200, response.status
  end

  test "should update a client" do
    client = clients(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    patch "/v1/clients/#{client.id}", params: { full_name: "Updated" }, headers: headers
    assert_equal 200, response.status
    update_body = JSON.parse(response.body)

    assert_instance_of Hash, update_body
    assert_equal "Updated", update_body['full_name']

    get "/v1/clients/#{client.id}"
    get_body = JSON.parse(response.body)

    assert_equal update_body['full_name'], get_body['full_name']
  end

  test "should destroy a category" do
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/clients/", params: { full_name: "Test client", email: "test.client@email.com", phone: "999999999", age: 99 }, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    delete "/v1/clients/#{create_body['id']}", headers: headers
    assert_equal 200, response.status
    delete_body = JSON.parse(response.body)

    assert_instance_of Hash, delete_body
    assert_equal "true", delete_body['success']
  end

  test "should list orders for client" do
    client = clients(:one)
    order = orders(:one)

    get "/v1/clients/#{client.id}/orders"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal client.id, body['id']
    assert_equal client.full_name, body['full_name']
    assert_equal client.orders.ids[0], body['orders'][0]['id']
    assert_equal order.id, body['orders'][0]['id']
  end
end
