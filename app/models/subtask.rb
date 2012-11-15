# == Schema Information
#
# Table name: subtasks
#
#  id               :integer          not null, primary key
#  subtask_id       :integer
#  task_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  position_in_task :integer
#

class Subtask < ActiveRecord::Base
  attr_accessible :subtask, :task, :position_in_task

  validate :subtask, presence: true
  validate :task, presence: true
  #validate :position_in_task, presence: true

  belongs_to :task
  belongs_to :subtask, class_name: "Task"


  delegate :id,  :title, :description, :subtasks, :title=, :description=, :add_subtask, :add_subtasks,
           :subtask_valid?, :public?, :private?, :type, :type=, :visibility,
           to: :subtask


  after_save do |record|
    # unless record.task.subtasks.to_a.include? record
    #   record.task.subtasks << record
    # end
  end

  def destroy
    unless new_record?
      connection.delete(
        "DELETE FROM #{self.class.quoted_table_name} " +
        "WHERE #{connection.quote_column_name(self.class.primary_key)} = #{self[:id]}",
        "#{self.class.name} Destroy"
      )
    end

    @destroyed = true
    freeze
  end




end
