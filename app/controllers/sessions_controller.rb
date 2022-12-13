class SessionsController < ApplicationController
  def create
    artist = Artist.find_by(login: params[:session][:login])
    if artist && artist.authenticate(params[:session][:password])
      log_in artist
      redirect_to artist
    else
        render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
