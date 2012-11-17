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

  extend SearchService
  extend SortService


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

    # Uses Search and Sort Services to search for a term and sort the result
    # * *Returns* :
    #   - Array of sorted tasks
    def self.search_and_sort(term)
      Task.sort_by_title( Task.search_by_title( term ), term )
    end


    # Creates a new task and sets the ID if the task is based on an existing one
    def self.preview_task(*args)
      params = args.extract_options!
      #Create new task
      task = Task.new(title: params[:task][:title],
                description: params[:task][:description],
                private: params[:task][:private].to_i == 0 ? false : true,
                type: params[:task][:type]
              )
      # If it has an id, set it
      task.id = params[:task][:id] unless params[:task][:id].nil?
      task
    end

    # Creates lists of valid and invalid subtasks
    #
    # * *Args*    :
    #   - +task+ -> the  Task which is being previewed
    #   - +args+ -> a hash containing an array of task ids in [:task]['subtasks']
    # * *Returns* :
    #   - An array containing the task, an array of valid tasks, an array ofinvalid tasks
    #
    def self.preview_lists(task,*args )
      params = args.extract_options!
      subtasks = []
      invalid_subtasks = []
      unless params[:task]['subtasks'].nil?
        #Grab all subtasks
        subtasks =  Task.find(params[:task]['subtasks'])
        unless task.id.nil?
          # Remove invalid subtasks so they do not get rendered
          invalid_subtasks = task.validate_subtasks(subtasks)
          invalid_subtasks.each { |i| subtasks.delete(Task.find(i)) }
        end
      end
      [task, subtasks, invalid_subtasks]
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

    # Task an array of Task-IDs and returns an array with invalid tasks-IDs
    #
    # * *Args*    :
    #   - +subtasks+ -> Array of Task IDs
    # * *Returns* :
    #   - an array containing all invalid subtasks
    #
    def validate_subtasks(subtasks)
      array = []
      create_validator
      subtasks.each do |id|
        array << id unless @validator.valid? Task.find(id)
      end
      array
    end

    # Adds a task as a subtask if it is valid
    #
    # * *Args*    :
    #   - +task+ -> the Task to be added
    # * *Returns* :
    #   - nil if successful, an errormessage in a hash otherwise
    #
    def add_subtask(task)
      if validate_subtask?(task)
        self.subtasks.push Subtask.new(task: self, subtask: task)
        return Task.response(task, true)
      end
      Task.response(task, false)
    end





    # Adds all tasks as subtasks if each is valid
    #
    # * *Args*    :
    #   - +tasks+ -> An array of Tasks to be added
    # * *Returns* :
    #   - nil if all tasks were added, an array with an errormessage for each invalid subtask otherwise
    #
    def add_subtasks(tasks)
      array = {}
      tasks.each do |element|
        error = add_subtask(element)
        array[task.id] = error unless error.nil?
      end
      array.length == 0 ? nil : array
    end



    # Generates a response for the view depending on the validity of the task
    # * *Args*    :
    #   - +task+ -> The task which is valid or invalid as a subtask
    #   - +valid+ -> The validity of the task
    # * *Returns* :
    #   - A string with the error or nil
    #
    def self.response(task, valid= true)
      t('task.invalid_subtask') unless valid
    end




end
