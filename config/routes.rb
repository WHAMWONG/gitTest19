require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # New route for creating todos
  post '/api/todos', to: 'api/todos#create'
  # Existing route for validating todos
  get '/api/todos/validate', to: 'api/todos#validate'
end
