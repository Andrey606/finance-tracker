class AddMyTypeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :my_type, :string
  end
end
