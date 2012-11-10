class TasksController < ApplicationController


  def index
    @tasks = Task.where(private: false)#.paginate(:page => params[:page], per_page: 5)
    # if params[:private]
    #   @task.private = @task.public?
    #   @task.save
    #   flash.now[:notice] = "Changed task from #{ @task.not_visibility } to #{ @task.visibility }"
    # end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def list_subtasks
    @tasks = Task.where("private = ? and title LIKE ?",false, "%#{params[:search]}%").order("title ASC")
    begins_with = /^#{params[:search]}.*$/i
    word_begins_with = /^.* #{params[:search]}.*$/i
    first = @tasks.find_all{|item| item.title =~ begins_with }
    second = @tasks.find_all{|item| item.title =~ word_begins_with }
    last = @tasks.to_a - first - second
    @tasks = first + second + last
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
        #TODO: Is the sequence of elements always the same in a hash?
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
          render json:  @task.errors.to_json,
            content_type: "json", status: 406
        }
      end
    end
  end

  def edit
    @task = Task.find(params[:id])
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
    redirect_to tasks_url, :notice => "Successfully destroyed task."
  end

  def show
    @task = Task.find(params[:id])
  end
end
