Rails.application.routes.draw do
  resources :users, except: [:new, :edit]
  post 'session' => 'session#create'
end
