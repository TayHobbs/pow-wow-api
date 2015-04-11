Rails.application.routes.draw do
  resources :users, except: [:new, :edit]
  post 'session' => 'session#create'
  post 'session/refresh' => 'session#refresh'
end
