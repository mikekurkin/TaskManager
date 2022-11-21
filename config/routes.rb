Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root to: 'web/boards#show'

  scope module: :web do
    resource :board, only: :show
    resources :developers, only: [:new, :create]
    resource :session, only: [:new, :create, :destroy]
    resource :password_recovery, only: [:new, :create, :show, :update]
  end

  namespace :admin do
    mount Sidekiq::Web, at: '/sidekiq'
    resources :users
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update, :destroy] do
        put '/attach_image', to: 'tasks#attach_image'
        put '/remove_image', to: 'tasks#remove_image'
      end
      resources :users, only: [:index, :show]
    end
  end
end
