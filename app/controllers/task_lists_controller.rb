class TaskListsController < ApplicationController

  def index
    from = Date.strptime(params[:start_date], "%m/%d/%Y") if params[:start_date]
    to = Date.strptime(params[:end_date], "%m/%d/%Y") if params[:end_date]
    if params[:start_date]
      @filtered = [from, to]
    elsif params[:name_search]
      @filtered = params[:name_search]
    end

    if params[:start_date] && params[:end_date]
      @tasks = Task.where(due_date: (from)..(to))
    elsif params[:name_search]
      @tasks = Task.where(["description LIKE :tag", tag: "%#{params[:name_search]}%"])
    else
      @task_lists = TaskList.order(:name)
    end
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
      redirect_to new_task_list_path, alert: "Your task list could not be created"
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
      redirect_to :back, alert: "Task List cannot be blank!"
    end
  end

  def show
    @task_list = TaskList.find(params[:id])
  end

  def show_completed
  end

  def destroy
    @task_list = TaskList.find(params[:id])
    @task_list.tasks.destroy_all
    @task_list.destroy

    redirect_to root_path, notice: "Task List was deleted successfully!"
  end

end