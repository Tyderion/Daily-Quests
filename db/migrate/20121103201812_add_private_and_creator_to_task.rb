class AddPrivateAndCreatorToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :private, :boolean
    add_column :tasks, :creator, :integer
  end
end
