class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :login
      t.string :password
      t.string :full_name
      t.string :nickname
      t.string :login_status

      t.timestamps
    end
  end
end
