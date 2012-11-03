class CreateTaskType < ActiveRecord::Migration
  def self.up
    create_table :task_types do |t|
      t.string :name
    end
    add_column :tasks, :typ, :integer #Maybe put not_null constraints here.
  end
  def self.down
    drop_table :task_types
    remove_column :tasks, :typ
  end
end
