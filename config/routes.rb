Rails.application.routes.draw do
  resources :task_lists do
    resources :tasks, except: [:destroy, :index]
    resources :completed, only: [:index, :create]
  end

  resources :tasks, only: [:destroy, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :about, only: :index

  root "task_lists#index"
  get "signout" => "sessions#destroy", as: :signout
end