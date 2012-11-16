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
    if validator.valid?(task)
      self.subtasks.push Subtask.new(task: self, subtask: task)
    end
    validator.valid?(task)
  end

  def validator
    @validator ||=  SubtaskValidatorWithCache.new(self)
  end


  def add_subtasks(tasks)
    tasks.each do |element|
      add_subtask(element)
    end
  end


end
