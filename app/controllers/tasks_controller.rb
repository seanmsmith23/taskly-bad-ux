class TasksController < ApplicationController

  def new
    @task = Task.new
    @users = User.all
    @task_list = TaskList.find(params[:task_list_id])
  end

  def create
    @task_list = TaskList.find(params[:task_list_id])
    @users = User.all
    date = Date.new( params[:task]["due_date(1i)"].to_i, params[:task]["due_date(2i)"].to_i, params[:task]["due_date(3i)"].to_i )
    @task = Task.create( user_id: current_user.id,
                         description: params[:task][:description],
                         due_date: date,
                         task_list_id: params[:task_list_id],
                         assigned_to: params[:task][:assigned_to],
                         assigned_to_2: params[:task][:assigned_to_2],
                         assigned_to_3: params[:task][:assigned_to_3],
                         assigned_to_4: params[:task][:assigned_to_4])

    if @task.valid?
      @task.save
      redirect_to root_path, notice: "Task was created successfully!"
    else
      render :new, alert: "Your task could not be created"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to root_path, notice: "Task was deleted successfully!"
  end

  def complete
    @task = Task.find(params[:id])
    @task.completed = true
    @task.save

    redirect_to root_path
  end

  def index
    @created = TaskList.created_by(current_user.id)
    @task_list = TaskList.assigned_to(current_user.name)
  end
end
