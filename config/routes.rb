Rails.application.routes.draw do
  get "test_sets/show"
  root "tasks#index"

  resources :tasks do
    resource :leaderboard, only: :show, module: :tasks
  end
  resources :test_sets, only: [ :show, :index ] do
    resource :leaderboard, only: :show, module: :test_sets
    resource :download, only: :show, module: :test_sets
  end
  resources :models, only: [ :index, :show ]
  resources :evaluators, only: [ :show ]
  resources :test_set, only: [ :show ]

  resources :submissions do
    resources :tasks, only: [ :index, :show ], module: :submissions
  end

  namespace :admin do
    resources :tasks do
      resources :groundtruths, only: [ :new, :create ], module: :tasks
    end
    resources :test_sets do
      resources :entries, only: :index, module: :test_sets
    end
    resources :evaluators
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Authentication
  direct(:sign_in) { "/auth/sso" }
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  delete "auth", to: "sessions#destroy", as: "sign_out"
end
