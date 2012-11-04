class TasksController < ApplicationController
  before_filter :get_detail_task

  def get_detail_task
    @task_detail = Task.find(params[:task_id]) if params[:task_id]
  end
  def index
    @tasks = Task.all
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

  def new
    @task = Task.new
    @tasks = Task.where(private: false)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @tasks = Task.where(private: false)
    subtasks = params[:task][:subtasks]
    params[:task].delete :subtasks
    #params[:task][:private] = params[:task][:parivate]==1 ? true : false
    params[:task].delete :type if params[:task][:type] == ""
    params[:task][:type] = TaskType.name_for params[:task][:type].to_i
    @task = Task.new(params[:task])
    if @task.save
      unless subtasks.nil?
        subtasks.each do |k,e|

          @task.add_subtask(Task.find(e))
        end
      end
      redirect_to @task, :notice => "Successfully created task."
    else
      params[:task][:subtasks] = subtasks
      render :action => 'new'
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
