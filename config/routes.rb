Rails.application.routes.draw do
  resources :users, except: [:new, :edit]
  resources :project
  get 'users/:email/forgot' => 'users#forgotten_password', :constraints => { :email => /.+@.+\..*/ }
  get 'users/:email/reset/:reset_code' => 'users#reset_password', :constraints => { :email => /.+@.+\..*/ }
  post 'session' => 'session#create'
end
