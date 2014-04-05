class AddUsedCountToAccessToken < ActiveRecord::Migration
  def change
  	add_column :access_tokens, :used_count, :integer, :default => 0
  end
end
