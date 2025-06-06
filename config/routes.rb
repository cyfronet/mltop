Rails.application.routes.draw do
  get "test_sets/show"

  constraints(-> { !_1.env["mltop.challenge_id"] }) do
    root to: "home#index"

    resources :challenges, except: [ :edit, :update ]
  end

  constraints(-> { _1.env["mltop.challenge_id"] }) do
    scope module: :challenges do
      root to: "tasks#index", as: :challenge_root

      resources :evaluators, only: [ :index ]
      resource :membership, only: :create

      resources :tasks do
        resource :leaderboard, only: :show, module: :tasks
      end
      resources :test_sets, only: [ :show, :index ] do
        resource :leaderboard, only: :show, module: :test_sets
      end
      resources :test_set, only: [ :show ]
      resources :models, only: [ :index, :show ]

      resources :submissions do
        resources :tasks, only: [ :index, :show ], module: :submissions
        resources :hypotheses, only: [ :create, :destroy ], module: :submissions, shallow: true do
          resource :evaluations, only: [ :create ]
        end
      end

      resources :evaluations, only: [ :create ] do
        resources :scores, only: [ :create ], defaults: { format: :json }, module: :evaluations
      end

      namespace :dashboard do
        resources :challenges, only: [ :edit, :update, :destroy ]
        resources :consents, except: [ :show ]
        resources :external_submissions, only: :index
        resources :tasks
        resources :test_sets do
          resources :entries, module: :test_sets, shallow: true, except: [ :index, :show ]
        end
        resources :evaluators do
          resources :metrics, module: :evaluators, shallow: true, except: [ :index, :show ]
        end

        resources :participants, only: :index do
          resources :hypotheses, only: :index, module: :participants
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Authentication
  direct(:plgrid_sign_in) { "/auth/plgrid" }
  direct(:github_sign_in) { "/auth/github" }
  direct(:google_sign_in) { "/auth/google_oauth2" }
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  get "sign_in", to: "sessions#new", as: "sign_in"
  delete "auth", to: "sessions#destroy", as: "sign_out"

  # errors
  get "/404", to: "errors#not_found", via: :all
  get "/500", to: "errors#server_error", via: :all

  mount MissionControl::Jobs::Engine, at: "/admin/jobs"
end
