class Task < ActiveRecord::Base
  attr_accessible :title, :description, :private, :type, :creator
  include RailsLookup
  lookup :task_type, as: :type


  self.inheritance_column = :inherit_type


  validates :title, presence: true
  validates :description, presence: true
  validates :creator, presence: true

  has_many :subtasks

    # Make it not generate an exception when trying to assign an empty type
    # Don't know why, but TaskType.id_for "Unknown string" returns nil instead of new ID.
    # Doesn't matter because that's also what it should be like xD
    def type=(t)
      if t.nil? or t.empty?
        # self.type_id = 0
        # self[:type] = nil
        t = "Task"
        self.type_id = TaskType.id_for t
      else
        #self[:type] = t
        self.type_id = TaskType.id_for t
      end
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
