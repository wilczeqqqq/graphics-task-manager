class AddIndexToArtistsLogin < ActiveRecord::Migration[7.0]
  def change
    add_index :artists, :login, unique: true
  end
end
