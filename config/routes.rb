Rails.application.routes.draw do
  resources :users, except: [:new, :edit]
  post 'user/:id/forgot' => 'users#forgotten_password'
  post 'session' => 'session#create'
end
