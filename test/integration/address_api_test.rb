require 'test_helper'

class AddressApiTest < ActionDispatch::IntegrationTest
  test "should return all addresses" do
    addresses = addresses(:three, :one)
    client = clients(:one)

    get "/v1/clients/#{client.id}/addresses"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    assert_equal addresses.map(&:attributes).map { |c| c.slice('id', 'address_line_1', 'address_line_2', 'city', 'postal_code', 'country') }, body
  end

  test "should return one address" do
    address = addresses(:one)
    client = clients(:one)

    get "/v1/clients/#{client.id}/addresses/#{address.id}"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal address.id, body['id']
    assert_equal address.address_line_1, body['address_line_1']
    assert_equal address.address_line_2, body['address_line_2']
    assert_equal address.city, body['city']
    assert_equal address.postal_code, body['postal_code']
    assert_equal address.country, body['country']
  end

  test "should create an address" do
    client = clients(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/clients/#{client.id}/addresses/", params: { address_line_1: "Address Line", address_line_2: "123", city: "city", postal_code: "00-000", country: "PL"}, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    assert_instance_of Hash, create_body
    assert_equal "Address Line", create_body['address_line_1']
    assert_equal "123", create_body['address_line_2']
    assert_equal "city", create_body['city']
    assert_equal "00-000", create_body['postal_code']
    assert_equal "PL", create_body['country']

    get "/v1/clients/#{client.id}/addresses/#{create_body['id']}"
    assert_equal 200, response.status
  end

  test "should update an address" do
    address = addresses(:one)
    client = clients(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    patch "/v1/clients/#{client.id}/addresses/#{address.id}", params: { address_line_1: "Lorem ipsum..." }, headers: headers
    assert_equal 200, response.status
    update_body = JSON.parse(response.body)

    assert_instance_of Hash, update_body
    assert_equal "Lorem ipsum...", update_body['address_line_1']

    get "/v1/clients/#{client.id}/addresses/#{address.id}"
    get_body = JSON.parse(response.body)

    assert_equal update_body['address_line_1'], get_body['address_line_1']
  end

  test "should destroy an address" do
    address = addresses(:one)
    client = clients(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    delete "/v1/clients/#{client.id}/addresses/#{address.id}", headers: headers
    assert_equal 200, response.status
    delete_body = JSON.parse(response.body)

    assert_instance_of Hash, delete_body
    assert_equal "true", delete_body['success']
  end
end
