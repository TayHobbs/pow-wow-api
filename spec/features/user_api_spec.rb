require 'rails_helper'

describe 'User Api', :type => :request do

  it 'requires a valid token to retrieve a list of users' do
    User.create!(user_attributes)
    get '/users'
    expect(response.status).to eq 401
  end

  it 'requires a valid token to retrieve a specific user' do
    User.create!(user_attributes)
    get '/users/1'
    expect(response.status).to eq 401
  end

  it 'does not require an auth token to create an user' do
    expect(User.all.count).to eq 0

    post '/users', {user: {email: 'test@test.com', username: 'test', password: 'asdf'}}
    expect(User.all.count).to equal 1
  end

  it 'returns user information after creating a user' do
    post '/users', {user: {email: 'test@test.com', username: 'test', password: 'asdf'}}
    expect(response.body).to eq(
      "{\"user\":{\"id\":1,\"username\":\"test\",\"email\":\"test@test.com\",\"admin\":false,\"password\":\"asdf\"}}")

  end

  it "returns a list of users when a valid token is provided" do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    get '/users', {}, { 'Authorization' => "Bearer #{api_key.access_token}" }
    expect(response.body).to eq(
      "{\"users\":[{\"id\":1,\"username\":\"William Wallace\",\"email\":\"william.wallace@scotland.com\",\"admin\":false,\"password\":null}]}")
  end

  it "returns user info when a valid token is provided" do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    get '/users/1', {}, { 'Authorization' => "Bearer #{api_key.access_token}" }
    expect(response.body).to eq(
      "{\"user\":{\"id\":1,\"username\":\"William Wallace\",\"email\":\"william.wallace@scotland.com\",\"admin\":false,\"password\":null}}")
  end

  it 'does not delete a user when no token present' do
    User.create!(user_attributes)
    delete '/users/1'
    expect(User.all.count).to eq 1
    expect(response.status).to eq 401
  end

  it 'deletes user and api_key when token is present' do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    delete '/users/1', {}, { 'Authorization' => "#{api_key.access_token}" }
    expect(User.all.count).to eq 0
    expect(ApiKey.all.count).to eq 0
    expect(response.body).to eq "{\"message\":\"Account successfully deleted!\"}"
  end

  it 'gracefully handles trying to delete a user that does not exist' do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    delete '/users/2', {}, { 'Authorization' => "#{api_key.access_token}" }
    expect(response.body).to eq "{\"error\":\"This account doesn't exist!\"}"
  end

  it 'only lets a user delete themselves' do
    user_one = User.create!(user_attributes)
    User.create!(user_attributes(:id => 2, :username => 'test', :email => 'test@test.com'))
    api_key = user_one.session_api_key
    delete '/users/2', {}, { 'Authorization' => "#{api_key.access_token}" }
    expect(response.body).to eq "{\"error\":\"You can only delete your own account!\"}"
  end

end
