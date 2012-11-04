class CreateTaskType < ActiveRecord::Migration
  def self.up
    create_table :task_types do |t|
      t.string :name
    end
    #rename_column :tasks, :type, :inherit_type #Maybe put not_null constraints here.
    add_column :tasks, :type, :integer
  end
  def self.down
    drop_table :task_types
    remove_column :tasks, :type
  end
end
