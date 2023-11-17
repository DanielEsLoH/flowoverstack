Rails.application.routes.draw do
  devise_for :users
  root "questions#index"
  resources :questions do
    resources :comments, only: :create
    resources :votes, only: [:create, :destroy]
    collection do
      get 'search'
    end
    resources :answers, only: [:create] do
      resources :comments, only: :create
      resources :votes, only: [:create, :destroy]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
