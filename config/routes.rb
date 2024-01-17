require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Route for creating todos
  post '/api/todos', to: 'api/todos#create'
  
  # Route for validating todos
  get '/api/todos/validate', to: 'api/todos#validate'
  
  # Route for deleting todos
  delete '/api/todos/:id', to: 'api/todos#destroy'
  
  # Route for creating attachments for a todo
  post '/api/todos/:todo_id/attachments', to: 'api/todos#create_attachment'
  
  # Route for logging deletion of a todo (from new code)
  post '/api/audit_logs', to: 'api/todos#log_deletion'
end
