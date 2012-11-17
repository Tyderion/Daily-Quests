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
  #Todo: Fix Task.create
  #Todo: Refactor update_attributes and make it work
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

  after_destroy :destroy_subtasks

  #Todo: Test presence
  extend SearchService
  extend SortService


  private
    def create_validator(*args)
      @validator ||=  SubtaskValidatorWithCache.new(self) unless self.id.nil?
    end

    def destroy_subtasks
      #Todo: Tests
      subtasks = Subtask.where("task_id = ? or subtask_id = ?", self.id, self.id)
      subtasks.each { |s| s.destroy }
    end

    def self.check_new_parameters(*args)
      params = args.extract_options!
      if params[:type].blank?
        #Default type is Task
        params[:type] = TaskType.name_for 1
      else
        params[:type] = TaskType.name_for params[:type].to_i
      end
      unless params[:private].class == FalseClass
        params[:private] = params[:private].to_i == 0 ? false : true
      end
      params.delete :subtasks
      params
    end
  public
    def self.new(*args)
      params = args.extract_options!
      params = params[:task] if params[:task]
      task_params = Task.check_new_parameters( params )
      super(task_params)
    end


    def save(*args)
      result = super()
      params = args.extract_options!
      self.add_subtasks(params[:subtasks]) unless !result || params.nil?
      result
    end

    def update_attributes(*args)
      #Todo: Extract this method into a SubtaskManager or something like that
      params = args.extract_options!
      subtasks = nil
      params.delete :id unless params[:id].nil?
      unless params[:subtasks].nil?
        subtasks = params[:subtasks]
        params.delete :subtasks
      end
      result = super(params)
      debugger
      missing_subtask_list = (self.subtasks - subtasks.map{|k,v| Task.find(v.to_i) }).map {|e| Task.find(e.id) }
      # Todo only add if super() worked, else just validate
      self.add_subtasks(missing_subtask_list)
      result && self.errors.messages.length == 0
    end




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
    #   - An array containing an array of valid tasks and an array of invalid tasks
    #
    def preview_lists(*args )
      params = args.extract_options!
      subtasks = []
      invalid_subtasks = []
      unless params[:task]['subtasks'].nil?
        subtask_ids = params[:task]['subtasks']
        #Grab all subtasks
        subtasks_unnumbered = Task.find(subtask_ids.uniq)
        unless self.id.nil?
          # Remove invalid subtasks so they do not get rendered
          invalid_subtasks = self.validate_subtasks(subtasks_unnumbered)
          invalid_subtasks.each do |i|
            subtasks.delete(Task.find(i))
            subtasks_ids.delete(i)
          end
        end
        #Create a hash from the valid tasks
        unnumbered_hash = Hash[subtasks_unnumbered.map{|t| [t.id, t]}]
        # Add the tasks in the correct sequence and number to the subtasks array
        subtask_ids.each do |id|
          subtasks << unnumbered_hash[id.to_i]
        end
      end
      [subtasks, invalid_subtasks]
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
      create_validator.valid?(other)
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
      subtasks.each do |id|
        array << id unless validate_subtask(Task.find(id))
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
    # Adds errorsmessages to the task object
    #
    # * *Args*    :
    #   - +tasks+ -> An array of Tasks to be added
    # * *Returns* :
    #   - the task
    #
    def add_subtasks(tasks)
      array = {}
      unless tasks.nil?
        tasks.each do |element|
          error = add_subtask(element)
          self.errors.add("subtask#{element.id}", error) unless error.nil?
        end
      end
      self
    end



    # Generates a response for the view depending on the validity of the task
    # * *Args*    :
    #   - +task+ -> The task which is valid or invalid as a subtask
    #   - +valid+ -> The validity of the task
    # * *Returns* :
    #   - A string with the error or nil
    #
    def self.response(task, valid= true)
      I18n.t('task.invalid_subtask') unless valid
    end




end
