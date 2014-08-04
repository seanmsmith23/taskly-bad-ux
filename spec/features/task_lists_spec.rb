require 'rails_helper'
require 'capybara/rails'

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