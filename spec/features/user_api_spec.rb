require 'rails_helper'

describe 'User Api', :type => :request do

  it 'requires a valid token to retrieve a list of users' do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    get '/users', {}, { 'Authorization' => "Bearer #{api_key.access_token}" }
    expect(response.status).to eq 403
    expect(response.body).to eq(
      "{\"error\":\"You do not have the proper access to view this page.\"}")
  end

  it 'requires a user to be an admin to retrieve a list of users' do
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

  it "returns a list of users when a valid token is provided and user is admin" do
    user = User.create!(user_attributes(:admin => true))
    api_key = user.session_api_key
    get '/users', {}, { 'Authorization' => "Bearer #{api_key.access_token}" }
    expect(response.body).to eq(
      "{\"users\":[{\"id\":1,\"username\":\"William Wallace\",\"email\":\"william.wallace@scotland.com\",\"admin\":true,\"password\":null}]}")
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
    expect(response.body).to eq "{}"
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
    expect(response.status).to eq 403
    expect(response.body).to eq "{\"error\":\"You can only delete your own account!\"}"
  end

  it 'does not update a user when no token present' do
    User.create!(user_attributes)
    put '/users/1', {user: {email: 'test@test.com', username: 'test'}}
    expect(response.status).to eq 403
    expect(User.find(1).username).to eq 'William Wallace'
  end

  it 'updates user when token is present' do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    patch('/users/1',
      {user: {email: 'test@test.com', username: 'test', password: 'Testing1'}},
      { 'Authorization' => "#{api_key.access_token}" })
    expect(response.status).to eq 200
    expect(User.find(1).username).to eq 'test'
    expect(response.body).to eq "{\"user\":{\"id\":1,\"username\":\"test\",\"email\":\"test@test.com\",\"admin\":false,\"password\":\"Testing1\"}}"
  end

  it 'gracefully handles trying to update a user that does not exist' do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    patch '/users/2', {}, { 'Authorization' => "#{api_key.access_token}" }
    expect(response.body).to eq "{\"error\":\"This account doesn't exist!\"}"
  end

  it 'only lets a user edit themselves' do
    user_one = User.create!(user_attributes)
    User.create!(user_attributes(:id => 2, :username => 'test', :email => 'test@test.com'))
    api_key = user_one.session_api_key
    patch '/users/2', {}, { 'Authorization' => "#{api_key.access_token}" }
    expect(response.status).to eq 403
    expect(response.body).to eq "{\"error\":\"You can only edit your own account!\"}"
  end

  it 'lets an admin user edit another user' do
    admin = User.create!(user_attributes(:username => 'test', :email => 'test@test.com', :admin => true))
    User.create!(user_attributes(:id => 2))
    api_key = admin.session_api_key
    patch '/users/2', { 'user': {'username': 'testUser'} }, { 'Authorization' => "#{api_key.access_token}" }
    expect(response.status).to eq 200
    expect(response.body).to eq(
      "{\"user\":{\"id\":2,\"username\":\"testUser\",\"email\":\"william.wallace@scotland.com\",\"admin\":false,\"password\":null}}")
  end

  it 'sends the user a password reset email from forgotten_password action' do
    ActionMailer::Base.deliveries = []
    User.create!(user_attributes)
    get '/users/william.wallace@scotland.com/forgot'
    expect(ActionMailer::Base.deliveries.count).to eq 1
  end

  it 'does not reset the password if the password_reset_code is incorrect' do
    ActionMailer::Base.deliveries = []
    user = User.create!(user_attributes)
    get "/users/#{user.email}/reset/incorrect!"
    expect(ActionMailer::Base.deliveries.count).to eq 0
  end

  it 'resets the password from the reset_password action' do
    user = User.create!(user_attributes)
    get "/users/#{user.email}/reset/#{user.password_reset_code}"
    expect(user.username).to eq(User.find(1).username)
    expect(user.password).not_to eq(User.find(1).password)
  end

  it 'changes the password_reset_code after changing the user password' do
    user = User.create!(user_attributes)
    get "/users/#{user.email}/reset/#{user.password_reset_code}"
    expect(user.username).to eq(User.find(1).username)
    expect(user.password_reset_code).not_to eq(User.find(1).password_reset_code)
  end

  it 'sends the user an email after resetting the password' do
    ActionMailer::Base.deliveries = []
    user = User.create!(user_attributes)
    get "/users/#{user.email}/reset/#{user.password_reset_code}"
    expect(ActionMailer::Base.deliveries.count).to eq 1
  end

end
