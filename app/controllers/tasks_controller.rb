class TasksController < ApplicationController


  def index
    @tasks = Task.where(private: false)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def list_subtasks
    @tasks = Task.where("private = ? and title LIKE ?",false, "%#{params[:search]}%").order("title ASC")
    unless params[:search].empty?
      begins_with = /^#{params[:search]}.*$/i
      word_begins_with = /^.* #{params[:search]}.*$/i
      first = @tasks.find_all{|item| item.title =~ begins_with }
      second = @tasks.find_all{|item| item.title =~ word_begins_with }
      last = @tasks.to_a - first - second
      @tasks = first + second + last
    end
    respond_to do |format|
      format.js
    end
  end

  def details
    #debugger
    @task_detail = Task.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def new
    @task = Task.new
    @tasks = Task.where(private: false)#.paginate(:page => params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    valid = true
    subtasks = params[:task][:subtasks]
    params[:task].delete :subtasks
    type_error = false

    if params[:task][:type].empty?
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
      redirect_to @task, :notice => "Successfully created task."
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
    @task = Task.find(params[:id])
    @tasks = Task.where(private: false)
  end

  def preview
    @task_detail = Task.new(
            title: params[:task][:title],
            description: params[:task][:description],
            private: params[:task][:private].to_i == 0 ? false : true,
            type: params[:task][:type]
          )
    @subtasks = []
    unless params[:task]['subtasks'].nil?
      params[:task]['subtasks'].each do |sub|
        @subtasks << Task.find(sub.to_i)
      end
    end
    respond_to do |format|
      format.js
    end

  end

  def update
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
