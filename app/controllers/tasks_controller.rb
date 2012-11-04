class TasksController < ApplicationController
  def index
    @tasks = Task.all
    @task = Task.find(params[:task_id]) if params[:task_id]
    if params[:private]
      @task.private = @task.public?
      @task.save
      flash.now[:notice] = "Changed task from #{ @task.not_visibility } to #{ @task.visibility }"
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task])
    @task.private = false if @task.private.nil?
    if @task.save
      redirect_to @task, :notice => "Successfully created task."
    else
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
