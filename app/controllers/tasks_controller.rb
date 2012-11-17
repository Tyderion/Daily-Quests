class TasksController < ApplicationController
  #Todo: Refactor update
  #Todo: Write Tests
  #Todo: Write Comments

  def index
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
    @task_detail = Task.find(params[:id])
    respond_to do |format|
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
    @task = Task.new(params[:task])
    @tasks = Task.where(private: false)
    #Todo: Display Notice and Really redirect xD
    respond_to do |format|
      if @task.save(params[:task])
        redirect_to tasks_path, :notice => "Successfully created task."
      else
        format.json {
          render json:
          { errors: @task.errors.to_json
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
    @task_detail =  Task.preview_task(params)
    @subtasks, @invalid_subtasks = @task_detail.preview_lists(params)
    respond_to do |format|
      format.js
    end

  end

  def update
    #Looks ok, but does it do what is should?
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.js
      else
        format.json {
            render json:
            { errors: @task.errors.to_json
              }, content_type: "json", status: 406
          }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    respond_to do |format|
      format.json {
        render json: { message: "Successfully destroyed task"},
        content_type: "json", status: :ok
      }
    end
  end

end
