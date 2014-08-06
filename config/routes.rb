Rails.application.routes.draw do
  resources :task_lists do
    resources :tasks, except: [:destroy]
  end
  resources :tasks, only: [:destroy]

  root "task_lists#index"

  get "about" => "about#show", as: :about
  patch "task/complete" => "tasks#complete"
  get "task_list/:id/completed" => "task_lists#show_completed"

  ## Original Routes ##

  get "signin" => "sessions#new", as: :signin
  post "signin" => "sessions#create"
  get "signout" => "sessions#destroy", as: :signout
end
