class AddRefreshTokenToApiKey < ActiveRecord::Migration
  def self.up
    add_column :api_keys, :refresh_token, :string
  end

  def self.down
    remove_column :api_keys, :refresh_token
  end
end
