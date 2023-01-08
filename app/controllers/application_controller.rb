class ApplicationController < ActionController::API
  include JsonWebToken

  private
  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    if Rails.env.development? || Rails.env.test?
      if header == 'admin_token'     # IT'S ONLY FOR EDUCATIONAL AND TESTING PURPOSES #
        set_admin_token  # IT SHOULD NEVER BE USED IN PRODUCTION ENVIRONMENTS #
      else
        set_artist_token(header)
      end
    else
      set_artist_token(header)
    end
  end

  private

  def set_artist_token(header)
    decoded = jwt_decode(header)
    @current_artist = Artist.find(decoded[:artist_id])
  end

  def set_admin_token
    @current_artist = 'admin'
  end
end
