class RemoveScopeFromApiKey < ActiveRecord::Migration
  def self.up
    remove_column :api_keys, :scope
  end

  def self.down
    add_column :api_keys, :scope, :string
  end
end
