class TasksController < ApplicationController

  def new
    @task = Task.new
  end

  def create
    date = Date.new( params[:task]["due_date(1i)"].to_i, params[:task]["due_date(2i)"].to_i, params[:task]["due_date(3i)"].to_i )

    @task = Task.create( user_id: current_user.id,
                         description: params[:task][:description],
                         due_date: date,
                         task_list_id: params[:id] )
    p '*' * 80
    p date
    p '*' * 80

    if @task.valid?
      @task.save
      redirect_to root_path, notice: "Task was created successfully!"
    end
  end

end
