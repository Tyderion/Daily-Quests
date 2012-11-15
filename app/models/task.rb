# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  private     :boolean
#  creator     :integer
#  type        :integer
#

class Task < ActiveRecord::Base
  attr_accessible :title, :description, :private, :type, :creator
  include RailsLookup
  lookup :task_type, as: :type


  self.inheritance_column = :inherit_type

  validates :creator, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :private, :inclusion => {:in => [true, false]}


  has_many :subtasks

    # Make it not generate an exception when trying to assign an empty type
    def type=(t)
      if t.blank?
        t = "Task"
      end
      id = TaskType.id_for(t) || TaskType.gen_id_for(t)
      self.type_id = id
    end


  def visibility
    private? ? I18n.t('task.private') : I18n.t('task.public')
  end

  def not_visibility
    private? ?  I18n.t('task.public') : I18n.t('task.private')
  end


  def public?
    not private?
  end
  def private?
    private
  end

  def add_subtask(task)

    self.subtasks.push Subtask.new(task: self, subtask: task) if subtask_valid?(task)
  end

  def subtask_valid?(other)
    if other.id == self.id || !type_valid?(other)
      return false
    else
      return subtasks_valid?(other.subtasks)
    end
  end

  def add_subtasks(tasks)
    tasks.each do |element|
      add_subtask(element)
    end
  end

  def subtasks_valid(subtasks)
    errors = []
    subtasks.each { |sub| errors << sub.id unless subtask_valid?(sub) }
    return errors
  end

  private
  def subtasks_valid?(subtasks)
    subtasks.each do |task|
      return false unless subtask_valid?(task)
    end
    true
  end

  def type_valid?(other)
    if self.type == TaskType.name_for(1)
      other.type == TaskType.name_for(1)
    elsif self.type == TaskType.name_for(2)
      other.type == TaskType.name_for(1)
    elsif self.type == TaskType.name_for(3)
      other.type = TaskType.name_for(2)
    end
  end


end