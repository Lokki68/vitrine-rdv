Rails.application.routes.draw do
  root "pages#home"

  resources :posts, only: %i[index show], path: "blog", param: :slug

  resource :session, only: %i[new create destroy]
  resources :passwords, param: :token, only: %i[new create edit update]

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
    root "dashboard#index"

    resources :appointments, only: %i[index show] do
      member { patch :cancel }
    end
    resources :payments, only: :index
    resources :availabilities, except: :show
    resources :blog_posts, path: 'articles' do
      member do
        patch :publish
        patch :unpublish
      end
    end

    post 'uploads/images', to: "uploads#image", as: :upload_image
  end
end
