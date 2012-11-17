class TasksController < ApplicationController
  #Todo: Reduce Complexity by moving a out of the controller
  #Todo: Write Tests
  #Todo: Write Comments

  def index
    # Looks ok
    @tasks = Task.where(private: false)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search_subtasks_list
    @tasks = Task.search_and_sort(params[:search])
    respond_to do |format|
      format.js
    end
  end

  def details
    # This one looks ok
    @task_detail = Task.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def new
    # This one looks ok
    @task = Task.new
    @tasks = Task.where(private: false)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    #debugger
    valid = true
    subtasks = params[:task][:subtasks]
    params[:task].delete :subtasks
    type_error = false

    if params[:task][:type].blank?
      params[:task][:type] = "Task"
      type_error = true
    else
      params[:task][:type] = TaskType.name_for params[:task][:type].to_i
    end
    @task = Task.new(params[:task])
    @tasks = Task.where(private: false).paginate(:page => params[:page], per_page: 5)

    if @task.valid? && !type_error
      @task.save
      unless subtasks.nil?
        subtasks.each do |k,e|
          @task.add_subtask(Task.find(e))
        end
      end
      #Todo: Display Notice and Really redirect xD
      redirect_to tasks_path, :notice => "Successfully created task."
    else
      if type_error
        @task.errors.add :type, "Can't be blank."
      end
      params[:task][:subtasks] = subtasks

      respond_to do |format|
        format.json {
          render json:
          { errors: @task.errors.to_json,
            subtasks: params[:task][:subtasks].to_json
            }, content_type: "json", status: 406
        }
      end
    end
  end

  def edit
    # Looks ok
    @task = Task.find(params[:id])
    @tasks = Task.where(private: false)
  end

  def preview
    if params[:task][:id].nil?
      #If it is a new task, create it
      @task_detail = Task.new(
              title: params[:task][:title],
              description: params[:task][:description],
              private: params[:task][:private].to_i == 0 ? false : true,
              type: params[:task][:type]
            )
    else
      #Grab the existing one
      @task_detail = Task.find(params[:task][:id])
    end
    @subtasks = []
    @invalid_subtasks = []
    unless params[:task]['subtasks'].nil?
      #Grab all subtasks
      @subtasks =  Task.find(params[:task]['subtasks'])
      unless @task_detail.id.nil?
        #Note: to myself: What is this?
        @invalid_subtasks = @task_detail.subtasks_valid(@subtasks)
        @invalid_subtasks.each { |i| @subtasks.delete(Task.find(i)) }
      end
    end

    respond_to do |format|
      format.js
    end

  end

  def update
    #Looks ok, but does it do what is should?
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      redirect_to @task, :notice  => "Successfully updated task."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    #This needs to go into the model
    subtasks = Subtask.where("task_id = ? or subtask_id = ?", params[:id], params[:id])   #.select("id")
    subtasks.each { |s| s.destroy }
    #redirect_to tasks_url, :notice => "Successfully destroyed task."
    respond_to do |format|
      format.json {
        render json: { message: "Successfully destroyed task"},
        content_type: "json", status: :ok
      }
    end
  end

end
