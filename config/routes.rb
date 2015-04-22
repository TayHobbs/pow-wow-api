Rails.application.routes.draw do
  resources :users, except: [:new, :edit]
  get 'users/:email/forgot' => 'users#forgotten_password', :constraints => { :email => /.+@.+\..*/ }
  post 'session' => 'session#create'
end
