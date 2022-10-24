class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :login
      t.string :password
      t.string :full_name
      t.string :login_status

      t.timestamps
    end
  end
end
