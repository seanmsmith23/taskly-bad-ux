class CompletedController < ApplicationController

  def create
    @task = Task.find(params[:task_list_id])
    @task.completed = true
    @task.save

    redirect_to root_path
  end

  def index
    @task_list = TaskList.find(params[:task_list_id])
  end

end
