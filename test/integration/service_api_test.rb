require 'test_helper'

class ServiceApiTest < ActionDispatch::IntegrationTest
  test "should return all services" do
    services = services(:two, :one)
    categories = categories(:two, :one)

    get "/v1/services"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    assert_equal services[0].id, body[0]['id']
    assert_equal services[1].id, body[1]['id']
    assert_equal services[0].category.id, body[0]['category']['id']
    assert_equal categories[0].id, body[0]['category']['id']
    assert_equal services[1].category.id, body[1]['category']['id']
    assert_equal categories[1].id, body[1]['category']['id']
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

  test "should create a service" do
    category = categories(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/services/", params: { name: "Test service", category_id: "#{category.id}" }, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    assert_instance_of Hash, create_body
    assert_equal "Test service", create_body['name']
    assert_equal category.id, create_body['category']['id']

    get "/v1/services/#{create_body['id']}"
    assert_equal 200, response.status
  end

  test "should update a service" do
    category = categories(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    patch "/v1/services/#{category.id}", params: { name: "Updated" }, headers: headers
    assert_equal 200, response.status
    update_body = JSON.parse(response.body)

    assert_instance_of Hash, update_body
    assert_equal "Updated", update_body['name']

    get "/v1/services/#{category.id}"
    get_body = JSON.parse(response.body)

    assert_equal update_body['name'], get_body['name']
  end

  test "should destroy a service" do
    category = categories(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/services/", params: { name: "Test service", category_id: "#{category.id}" }, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    delete "/v1/services/#{create_body['id']}", headers: headers
    assert_equal 200, response.status
    delete_body = JSON.parse(response.body)

    assert_instance_of Hash, delete_body
    assert_equal "true", delete_body['success']
  end
end
