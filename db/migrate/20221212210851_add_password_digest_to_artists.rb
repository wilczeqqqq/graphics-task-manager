class AddPasswordDigestToArtists < ActiveRecord::Migration[7.0]
  def change
    add_column :artists, :password_digest, :string
  end
end
