Rails.application.routes.draw do
  root "pages#home"

  resources :blog_posts, only: %i[index show], path: "blog"

  namespace :admin do
    root "dashboard/index"
    get     "login",  to: "sessions#new"
    post    "login",  to: "sessions#create"
    delete  "logout", to: "sessions#destroy"
    resources :blog_posts
  end
end
