class TaskListsController < ApplicationController
  skip_before_action :ensure_current_user, only: :about

  def index
    @task_lists = TaskList.order(:name)
  end

  def about

  end

end