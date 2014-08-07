module TaskListsHelper
  def names_to_display(task)
    names = ""
    names << task.assigned_to if task.assigned_to != ""
    names << ", " + task.assigned_to_2 if task.assigned_to_2 != ""
    names << ", " + task.assigned_to_3 if task.assigned_to_3 != ""
    names << ", " + task.assigned_to_4 if task.assigned_to_4 != ""

    if names.count(',') == 1
      output = names.gsub(', ', '')
    else
      output = names
    end

    output
  end
end