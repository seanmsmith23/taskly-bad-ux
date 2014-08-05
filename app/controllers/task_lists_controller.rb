class TaskListsController < ApplicationController
  skip_before_action :ensure_current_user, only: :about

  def index
    @task_lists = TaskList.order(:name)
  end

  def about
  end

  def new
    @task_list = TaskList.new
  end

  def create
    @task_list = TaskList.create(name: params[:task_list][:name])

    if @task_list.valid?
      @task_list.save
      redirect_to root_path, notice: "Task List was created successfully!"
    else
      redirect_to task_list_new_path, alert: "Your task list could not be created"
    end

  end

  def edit
    @task_list = TaskList.find(params[:id])
  end

  def update
    @task_list = TaskList.find(params[:id])
    @task_list.name = params[:task_list][:name]

    if @task_list.valid?
      @task_list.save
      redirect_to root_path, notice: "Your task list was successfully updated!"
    else
      redirect_to :back
    end


  end

end