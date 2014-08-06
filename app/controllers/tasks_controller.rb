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
                         assigned_to: params[:task][:assigned_to])

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

end
