class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :user, index: true
      t.string :access_token
      t.string :scope
      t.datetime :expired_at
      t.datetime :created_at

      t.timestamps null: false
    end
    add_index :api_keys, :access_token, unique: true
    add_foreign_key :api_keys, :users
  end
end
