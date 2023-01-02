class ApplicationController < ActionController::API
  include JsonWebToken

  private
  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = jwt_decode(header)
    @current_artist = Artist.find(decoded[:artist_id])
  end
end
