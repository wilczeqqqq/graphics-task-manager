require "application_system_test_case"

class ArtistsTest < ApplicationSystemTestCase
  setup do
    @artist = artists(:one)
  end

  test "visiting the index" do
    visit artists_url
    assert_selector "h1", text: "Artists"
  end

  test "should create artist" do
    visit artists_url
    click_on "New artist"

    fill_in "Full name", with: @artist.full_name
    fill_in "Login", with: @artist.login
    fill_in "Login status", with: @artist.login_status
    fill_in "Nickname", with: @artist.nickname
    fill_in "Password", with: @artist.password
    click_on "Create Artist"

    assert_text "Artist was successfully created"
    click_on "Back"
  end

  test "should update Artist" do
    visit artist_url(@artist)
    click_on "Edit this artist", match: :first

    fill_in "Full name", with: @artist.full_name
    fill_in "Login", with: @artist.login
    fill_in "Login status", with: @artist.login_status
    fill_in "Nickname", with: @artist.nickname
    fill_in "Password", with: @artist.password
    click_on "Update Artist"

    assert_text "Artist was successfully updated"
    click_on "Back"
  end

  test "should destroy Artist" do
    visit artist_url(@artist)
    click_on "Destroy this artist", match: :first

    assert_text "Artist was successfully destroyed"
  end
end
