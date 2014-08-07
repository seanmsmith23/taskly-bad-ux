Rails.application.routes.draw do
  resources :task_lists do
    resources :tasks, except: [:destroy, :index]
  end

  resources :tasks, only: [:destroy, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :completed, only: [:index, :create]
  resources :about, only: :index

  root "task_lists#index"

  patch "task/complete" => "tasks#complete"
  get "task_list/:id/completed" => "task_lists#show_completed"

  get "signout" => "sessions#destroy", as: :signout
end
