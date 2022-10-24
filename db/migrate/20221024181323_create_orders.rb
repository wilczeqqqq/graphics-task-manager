class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :client, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.string :order_status

      t.timestamps
    end
  end
end
