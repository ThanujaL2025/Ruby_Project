Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  
  # Unified.to Widget routes
  get "unified-widget", to: "unified_widget#index"
  
  # Integrations routes (for Zendesk integration)
  resources :integrations, only: [:index]
  get 'test_zendesk_connection', to: 'integrations#test_connection'
  
  # Step 7: Data fetching endpoints (following tutorial)
  get 'fetch_employees', to: 'integrations#fetch_employees'
  get 'fetch_tickets', to: 'integrations#fetch_tickets'
  get 'fetch_contacts', to: 'integrations#fetch_contacts'
  get 'fetch_candidates', to: 'integrations#fetch_candidates'
  
  # Debug endpoint to see raw API response
  get 'debug_api_response', to: 'integrations#debug_api_response'
  
  # Multi-platform integration routes
  get 'multi-platform', to: 'multi_platform#index'
  get 'unified_customer_view', to: 'multi_platform#unified_customer_view'
  get 'platform_data', to: 'multi_platform#platform_data'
  post 'create_cross_platform_ticket', to: 'multi_platform#create_cross_platform_ticket'
  get 'platform_status', to: 'multi_platform#platform_status'
  get 'youtube_users', to: 'multi_platform#all_youtube_users_info'
  get 'youtube_user_profile', to: 'multi_platform#youtube_user_profile'
  

  
  root "unified_widget#index"
end
