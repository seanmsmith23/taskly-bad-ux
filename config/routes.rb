Rails.application.routes.draw do
  root "task_lists#index"
  get "signin" => "sessions#new", as: :signin
  post "signin" => "sessions#create"
  get "signout" => "sessions#destroy", as: :signout
  get "about" => "task_lists#about"
  get "task_list/new" => "task_lists#new"
  post "task_list/new" => "task_lists#create"
  get "task_list/:id/edit" => "task_lists#edit"
  patch "task_list/:id/edit" => "task_lists#update"
  get "task_list/:id/new_task" => "tasks#new"
  post "task_list/:id/new_task" => "tasks#create"
  delete "task/delete" => "tasks#destroy"
  get "task_list/:id" => "task_lists#show"
end
