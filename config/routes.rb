Rails.application.routes.draw do
  devise_for :users
  root "questions#index"
  resources :questions do
    resources :comments, only: :create
    resources :answers, only: [:create] do
      resources :comments, only: :create
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
