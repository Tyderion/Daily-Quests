# Representation of a Task
#
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


  after_initialize :create_validator


  private
    def create_validator
      @validator ||=  SubtaskValidatorWithCache.new(self) unless self.id.nil?
    end
  public

    # Make it not generate an exception when trying to assign an empty type
    def type=(t)
      if t.blank?
        t = "Task"
      end
      id = TaskType.id_for(t) || TaskType.gen_id_for(t)
      self.type_id = id
    end


    # Returns Visibility as string
    #
    # * *Returns* :
    #   - String "public" or "private"
    #
    def visibility
      private? ? I18n.t('task.private') : I18n.t('task.public')
    end

    # Returns Opposite Visibility as string
    #
    # * *Returns* :
    #   - String "public" or "private"
    #
    def not_visibility
      private? ?  I18n.t('task.public') : I18n.t('task.private')
    end

    # Returns true if task is public
    #
    # * *Returns* :
    #   - Boolean
    #
    def public?
      not private?
    end
    # Returns true if task is private
    #
    # * *Returns* :
    #   - Boolean
    #
    def private?
      private
    end


    # Tests if the other Task is a valid subtask
    #
    # * *Args*    :
    #   - +other+ -> the  Task to be tested
    # * *Returns* :
    #   - True if other is a valid task this task
    #
    def validate_subtask?(other)
      create_validator
      @validator.valid?(other)
    end

    # Adds a task as a subtask if it is valid
    #
    # * *Args*    :
    #   - +task+ -> the Task to be added
    # * *Returns* :
    #   - True if other has been added
    #
    def add_subtask(task)
      if validate_subtask?(task)
        self.subtasks.push Subtask.new(task: self, subtask: task)
        return true
      end
      false
    end


    # Adds all tasks as subtasks if each is valid
    #
    # * *Args*    :
    #   - +tasks+ -> An array of Tasks to be added
    # * *Returns* :
    #   - nothing
    #
    def add_subtasks(tasks)
      tasks.each do |element|
        add_subtask(element)
      end
    end




end
