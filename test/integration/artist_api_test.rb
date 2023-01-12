require 'test_helper'

class ArtistApiTest < ActionDispatch::IntegrationTest
  test "should return all artists" do
    artists = artists(:two, :one)

    get "/v1/artists"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Array, body
    assert_equal artists.map(&:attributes).map { |c| c.slice('id', 'login', 'bio', 'nickname', 'preferred_style', 'password_digest') }, body
  end

  test "should return one artist" do
    artist = artists(:one)

    get "/v1/artists/#{artist.id}"
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal artist.id, body['id']
    assert_equal artist.login, body['login']
    assert_equal artist.bio, body['bio']
    assert_equal artist.nickname, body['nickname']
    assert_equal artist.preferred_style, body['preferred_style']
    assert_equal artist.password_digest, body['password_digest']
  end

  test "should create an artist" do
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/artists/", params: { login: "artist", password: "password", nickname: "tester"}, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    assert_instance_of Hash, create_body
    assert_equal "artist", create_body['login']
    assert_equal "tester", create_body['nickname']
    assert_nil create_body['bio']
    assert_nil create_body['preferred_style']

    get "/v1/artists/#{create_body['id']}"
    assert_equal 200, response.status
  end

  test "should update an artist" do
    artist = artists(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    patch "/v1/artists/#{artist.id}", params: { bio: "Lorem ipsum..." }, headers: headers
    assert_equal 200, response.status
    update_body = JSON.parse(response.body)

    assert_instance_of Hash, update_body
    assert_equal "Lorem ipsum...", update_body['bio']

    get "/v1/artists/#{artist.id}"
    get_body = JSON.parse(response.body)

    assert_equal update_body['bio'], get_body['bio']
  end

  test "should destroy an artist" do
    headers = { 'Authorization' => 'Bearer admin_token' }

    post "/v1/artists/", params: { login: "artist", password: "password", nickname: "tester"}, headers: headers
    assert_equal 201, response.status
    create_body = JSON.parse(response.body)

    delete "/v1/artists/#{create_body['id']}", headers: headers
    assert_equal 200, response.status
    delete_body = JSON.parse(response.body)

    assert_instance_of Hash, delete_body
    assert_equal "true", delete_body['success']
  end

  test "should list orders for artist" do
    artist = artists(:one)
    order = orders(:one)
    headers = { 'Authorization' => 'Bearer admin_token' }

    get "/v1/artists/#{artist.id}/orders", headers: headers
    assert_equal 200, response.status
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_equal artist.id, body['id']
    assert_equal artist.orders.ids[0], body['orders'][0]['id']
    assert_equal order.id, body['orders'][0]['id']
  end
end
