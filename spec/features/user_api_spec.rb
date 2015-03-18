require 'rails_helper'

describe 'User Api', :type => :request do

  it 'requires a valid token to retrieve a list of users' do
    User.create!(user_attributes)
    get '/users'
    expect(response.body).to eq 1
  end

  # it 'requires a valid token to retrieve a specific user' do
  #   User.create!(user_attributes)
  #   get '/api/v1/users/1'
  #   expect(response.body).to include("Unauthorized.")
  # end

  # it 'does not require an auth token to create an user' do
  #   expect(User.all.count).to eq 0

  #   post '/api/v1/users/create', {email: 'test@test.com', username: 'test', password: 'asdf'}
  #   expect(response.body).to include('User successfully created!')
  #   expect(User.all.count).to equal 1
  # end

end
