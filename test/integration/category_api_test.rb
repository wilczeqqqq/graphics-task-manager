require 'test_helper'

class CategoryApiTest < ActionDispatch::IntegrationTest
  test "should return all categories" do
    categories = categories(:two, :one)

    get "/v1/categories"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    assert_equal categories.map(&:attributes).map { |c| c.slice('id', 'name') }, body
  end

  test "should return one category" do
    category = categories(:one)

    get "/v1/categories/#{category.id}"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal category.id, body['id']
    assert_equal category.name, body['name']
  end

  test "should create a category" do
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/categories/", params: { name: "Test category" }, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    assert_instance_of Hash, create_body
    assert_equal "Test category", create_body['name']

    get "/v1/categories/#{create_body['id']}"
    assert_equal 200, response.status
  end

  test "should update a category" do
    category = categories(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    patch "/v1/categories/#{category.id}", params: { name: "Updated" }, headers: headers
    assert_equal 200, response.status
    update_body = JSON.parse(response.body)

    assert_instance_of Hash, update_body
    assert_equal "Updated", update_body['name']

    get "/v1/categories/#{category.id}"
    get_body = JSON.parse(response.body)

    assert_equal update_body['name'], get_body['name']
  end

  test "should destroy a category" do
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/categories/", params: { name: "Test category" }, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    delete "/v1/categories/#{create_body['id']}", headers: headers
    assert_equal 200, response.status
    delete_body = JSON.parse(response.body)

    assert_instance_of Hash, delete_body
    assert_equal "true", delete_body['success']
  end

  test "should list services for category" do
    category = categories(:one)
    service = services(:one)

    get "/v1/categories/#{category.id}/services"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal category.id, body['id']
    assert_equal category.name, body['name']
    assert_equal category.services.ids[0], body['services'][0]['id']
    assert_equal service.id, body['services'][0]['id']
  end
end
