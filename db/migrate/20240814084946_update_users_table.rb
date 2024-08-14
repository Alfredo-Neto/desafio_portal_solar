class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :jti, :string
    add_column :users, :auth_token, :string, default: ""
    add_index :users, :auth_token, unique: true
  end
end
