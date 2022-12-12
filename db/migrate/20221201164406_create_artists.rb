class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :login
      t.string :nickname
      t.string :bio
      t.string :preferred_style
      t.string :token

      t.timestamps
    end
  end
end
