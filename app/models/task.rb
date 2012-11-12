class Task < ActiveRecord::Base
  attr_accessible :title, :description, :private, :type
  include RailsLookup
  lookup :task_type, as: :type


  self.inheritance_column = :inherit_type


  validates :title, presence: true
  validates :description, presence: true


  has_many :subtasks


  def visibility
    private? ? I18n.t('task.private') : I18n.t('task.public')
  end

  def not_visibility
    private? ?  I18n.t('task.public') : I18n.t('task.private')
  end


  def public?
    not private?
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
