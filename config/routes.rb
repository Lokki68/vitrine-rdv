Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "pages#home"

  resources :blog_posts, only: %i[index show], path: "blog"

  resources :appointments, path: 'rendez-vous', only: %i[new create show] do
    collection do
      get :slots
      get :confirmation
    end
  end

  namespace :webhooks do
    post "stripe", to: "stripe#create"
  end

  namespace :admin do
    root "dashboard/index"
    get     "login",  to: "sessions#new"
    post    "login",  to: "sessions#create"
    delete  "logout", to: "sessions#destroy"
    resources :blog_posts
  end
end
