require 'rails_helper'

describe 'Session Api', :type => :request do
  it 'authenticates with username' do
    user = User.create!(user_attributes)
    post '/session', { login: user.username, password: 'Testing1' }
    returned = eval(response.body)
    expect(returned[:api_key][:access_token]).to match(/\S{32}/)
    expect(returned[:api_key][:refresh_token]).to match(/\S{32}/)
    expect(returned[:api_key][:user_id]).to eq user.id
  end

  it 'authenticates with email' do
    user = User.create!(user_attributes)
    post '/session', { login: user.email, password: 'Testing1' }
    returned = eval(response.body)
    expect(returned[:api_key][:access_token]).to match(/\S{32}/)
    expect(returned[:api_key][:refresh_token]).to match(/\S{32}/)
    expect(returned[:api_key][:user_id]).to eq user.id
  end

  it 'response includes username' do
    user = User.create!(user_attributes)
    post '/session', { login: user.username, password: 'Testing1' }
    returned = eval(response.body)
    expect(returned[:username]).to eq user.username
  end

  it 'does not authenticate with invalid info' do
    user = User.create!(user_attributes)
    post '/session', { login: user.email, password: 'no good' }
    expect(response.status).to eq 401
  end

  it 'reauthenticates with a valid refresh token' do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    get '/users/1', {}, { 'Authorization' => 'invalid', 'Refresh' => api_key.refresh_token}
    expect(response.body).to eq(
      '{"user":{"id":1,"username":"William Wallace","email":"william.wallace@scotland.com","admin":false,"password":null}}')
    expect(api_key.access_token).not_to eq(User.find(1).session_api_key.access_token)
  end

  it 'does not reauthenticate with an invalid refresh token' do
    get '/users/1', {}, { 'Authorization' => 'invalid', 'Refresh' => 'Invalid' }
    expect(response.status).to eq 401
  end

end
