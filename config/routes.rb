Rails.application.routes.draw do
  root "model_types#index"

  resources :model_types, only: [ :index, :show ]
  resources :models, only: [ :show ]
  resources :benchmarks, only: [ :show ], controller: "model_benchmarks", as: :model_benchmark

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
