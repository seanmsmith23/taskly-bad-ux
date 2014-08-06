require 'rails_helper'
require 'capybara/rails'
require 'launchy'

feature 'Task lists' do

  scenario 'User can view task lists' do
    create_user email: "user@example.com"
    TaskList.create!(name: "Work List")
    TaskList.create!(name: "Household Chores")

    visit signin_path
    click_on "Login"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    click_on "Login"
    expect(page).to have_content("Work List")
    expect(page).to have_content("Household Chores")
  end

  scenario "User can create a new task list and see it in 'My Lists'" do
    create_user email: "user@example.com"
    visit signin_path
    click_on "Login"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    click_on "Login"

    expect(page).to have_link("+ Add Task List")

    click_link("+ Add Task List")

    expect(page).to have_content("Add a task list")
    expect(page).to have_content("Name")
    expect(page).to have_button("Create Task List")

    fill_in "Name", with: "Exercise Tasks"
    click_button("Create Task List")

    expect(page).to have_content("Exercise Tasks")
    expect(page).to have_content("Task List was created successfully!")
  end

  scenario "User cannot provide a blank name when creating a new task list" do
    create_and_signin_user
    click_link("+ Add Task List")

    click_button("Create Task")

    expect(page).to have_content("Your task list could not be created")
  end

  scenario "User can edit a task list" do
    create_and_signin_user
    add_list("Some Tasks")

    expect(page).to have_link("Edit")

    click_link("Edit")

    expect(page).to have_content("Name")
    expect(find_field("Name").value).to eq("Some Tasks")
    expect(page).to have_button("Update Task List")

    fill_in "Name", with: "Some Other Tasks"
    click_button("Update Task List")

    expect(page).to have_content("Your task list was successfully updated!")
    expect(page).to have_content("Some Other Tasks")
  end

  scenario "User can add tasks to a task list" do
    create_and_signin_user
    add_list("Work List")

    within('.new-task') do
      expect(page).to have_link("+ Add Task")
      click_link("+ Add Task")
    end

    expect(page).to have_content("Description")
    expect(page).to have_content("Due date")

    fill_in "Description", with: "Finish adding tests"
    select "2014",  from: "task_due_date_1i"
    select "August",  from: "task_due_date_2i"
    select "6",  from: "task_due_date_3i"
    select "Some User", from: "task[assigned_to]"

    click_button("Create Task")

    expect(page).to have_content("Task was created successfully!")
    expect(page).to have_content("Finish adding tests")
    expect(page).to have_content("days")
  end

  scenario "User cannot add blank tasks" do
    create_and_signin_user
    add_list("Work List")
    within('.new-task') do
      expect(page).to have_link("+ Add Task")
      click_link("+ Add Task")
    end

    click_button("Create Task")

    expect(page).to have_content("Can't be blank")
  end

  scenario "User can delete tasks" do
    create_and_signin_user
    add_list("Work List")
    create_task("Finish that important thing")

    expect(page).to have_content("Finish that important thing")
    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(page).to_not have_content("Finish that important thing")
    expect(page).to have_content("Task was deleted successfully!")
  end

  scenario "Users can view a single task list's tasks" do
    create_and_signin_user
    add_list("Work List")
    create_task("Finish that important thing")
    add_list("Second List")

    expect(page).to have_link("Work List")
    expect(page).to have_link("Second List")

    click_link("Work List")

    expect(page).to have_content("Finish that important thing")
    expect(page).to have_content("Work List")
    expect(page).to_not have_content("Second List")
  end

  scenario "User can complete tasks" do
    create_and_signin_user
    add_list("Work List")
    create_task("Finish my job")

    expect(page).to have_button("Complete")
    expect(page).to have_content("Finish my job")

    click_button("Complete")

    expect(page).to_not have_button("Complete")
    expect(page).to_not have_content("Finish my job")
  end

  scenario "User can view completed tasks" do
    create_and_signin_user
    add_list("Work List")
    create_task("Finish my job")

    expect(page).to have_button("Complete")
    expect(page).to have_content("Finish my job")

    click_button("Complete")

    expect(page).to_not have_button("Complete")
    expect(page).to_not have_content("Finish my job")
    expect(page).to have_link("Completed")

    click_link("Completed")

    expect(page).to have_content("Finish my job")
    expect(page).to have_button("Delete")
  end

  scenario "Tasks should appear in chronological order" do
    create_and_signin_user
    add_list("Work List")
    create_task_date("Finish my job", 2)
    create_task_date("Start other job", 1)
    create_task_date("Third task", 3)

    within('.task-box') do
        within('.task:nth-of-type(1)') do
          expect(page).to have_content("1 days")
        end

        within('.task:nth-of-type(2)') do
          expect(page).to have_content("2 days")
        end

        within('.task:nth-of-type(3)') do
          expect(page).to have_content("3 days")
        end
    end
  end

  scenario "User should be able to delet a task list, which deletes its tasks as well" do
    create_and_signin_user
    add_list("Work List")
    create_task("New task")

    expect(page).to have_content("Work List")
    expect(page).to have_content("New task")
    expect(page).to have_link("Delete")

    click_link("Delete")

    expect(page).to have_content("Task List was deleted successfully!")

    expect(page).to_not have_content("Work List")
    expect(page).to_not have_content("New task")
  end

  scenario "Empty task lists should show a friendly message" do
    create_and_signin_user
    add_list("Work List")

    expect(page).to have_content("Nothing here to see!")
  end

  scenario "Users should be able to assign tasks to users" do
    create_user(name: "Jeff", email: "jeff@example.com")
    create_user(name: "Hunter", email: "hunter@example.com")
    visit signin_path
    click_on "Login"
    fill_in "Email", with: "jeff@example.com"
    fill_in "Password", with: "password"
    click_on "Login"
    add_list("Work List")

    within('#all-task-lists') do
      expect(page).to have_link("+ Add Task")
      first('.new-task').click_link("+ Add Task")
    end

    expect(page).to have_content("Assigned to")

    fill_in "Description", with: "Do some work"
    select "#{Date.today.year}",  from: "task_due_date_1i"
    select "#{Date.today.strftime('%B')}",  from: "task_due_date_2i"
    select "#{Date.today.day}",  from: "task_due_date_3i"
    select "Hunter", from: "task[assigned_to]"
    click_button("Create Task")

    expect(page).to have_content("Do some work")
    expect(page).to have_content("- Hunter")
  end

  scenario "Edit task_list form should show validations" do
    create_and_signin_user
    add_list("Work List")
    click_link("Edit")
    fill_in "Name", with: ""
    click_button("Update Task List")

    expect(page).to have_content("Task List cannot be blank!")
  end

  scenario "Creating a task with a due date in the past should not be valid" do
    create_and_signin_user
    add_list("Work List")
    create_task_date("Some Task", -3)

    expect(page).to have_content("Due date cannot be in the past!")
  end

  scenario "Creating a task without assigning a user will return an error" do
    create_and_signin_user
    add_list("Work List")
    within('#all-task-lists') do
      expect(page).to have_link("+ Add Task")
      first('.new-task').click_link("+ Add Task")
    end

    fill_in "Description", with: "Some task"
    select "#{Date.today.year}",  from: "task_due_date_1i"
    select "#{Date.today.strftime('%B')}",  from: "task_due_date_2i"
    select "#{Date.today.day}",  from: "task_due_date_3i"
    click_button("Create Task")

    expect(page).to have_content("Must assign task to a user")
  end

  scenario "Users can click 'My Tasks' and see all tasks that have been assigned to them." do
    create_and_signin_user
    add_list("Work List")
    create_task("Some Task")

    expect(page).to have_content("My Tasks")

    click_link("My Tasks")

    expect(page).to have_content("Work List")
    expect(page).to have_content("Some Task")
  end

end

feature 'Logged Out' do

  scenario 'User can click on About to get more information about the app' do
    visit '/'

    expect(page).to have_link("About")

    click_link("About")

    expect(page).to have_content("About")
    expect(page).to have_content("This app is intended")
  end
end




### HELPER METHODS ###

def create_and_signin_user
  create_user email: "user@example.com"
  visit signin_path
  click_on "Login"
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "password"
  click_on "Login"
end

def add_list(name)
  click_link("+ Add Task List")
  fill_in "Name", with: name
  click_button("Create Task List")
end

def select_date(date, options = {})
  field = options[:from]
  select date.strftime('%Y'), :from => "#{field}_1i" #year
  select date.strftime('%B'), :from => "#{field}_2i" #month
  select date.strftime('%d'), :from => "#{field}_3i" #day
end

def create_task(description)
  within('#all-task-lists') do
    expect(page).to have_link("+ Add Task")
    first('.new-task').click_link("+ Add Task")
  end

  fill_in "Description", with: description
  select "#{Date.today.year}",  from: "task_due_date_1i"
  select "#{Date.today.strftime('%B')}",  from: "task_due_date_2i"
  select "#{Date.today.day}",  from: "task_due_date_3i"
  select "Some User", from: "task[assigned_to]"

  click_button("Create Task")
end

def create_task_date(description, day)
  within('#all-task-lists') do
    expect(page).to have_link("+ Add Task")
    first('.new-task').click_link("+ Add Task")
  end

  fill_in "Description", with: description
  select "#{Date.today.year}",  from: "task_due_date_1i"
  select "#{Date.today.strftime('%B')}",  from: "task_due_date_2i"
  select "#{Date.today.day + day}",  from: "task_due_date_3i"
  select "Some User", from: "task[assigned_to]"
  click_button("Create Task")
end

def showme
  save_and_open_page
end