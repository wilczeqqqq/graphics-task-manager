require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = clients(:client_one)
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end

  test "should get new" do
    get new_client_url
    assert_response :success
  end

  test "should create client" do
    assert_difference("Client.count") do
      post clients_url, params: { client: { full_name: @client.full_name, login: @client.login, login_status: @client.login_status, password: @client.password } }
    end

    assert_redirected_to client_url(Client.last)
  end

  test "should show client" do
    get client_url(@client)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_url(@client)
    assert_response :success
  end

  test "should update client" do
    patch client_url(@client), params: { client: { full_name: @client.full_name, login: @client.login, login_status: @client.login_status, password: @client.password } }
    assert_redirected_to client_url(@client)
  end

  # test "should destroy client" do
  #   assert_difference("Client.count", -1) do
  #     delete client_url(@client)
  #   end
  #
  #   assert_redirected_to clients_url
  # end
end
