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

    @task_list.save

    redirect_to root_path, notice: "Task List was created successfully!"
  end

end