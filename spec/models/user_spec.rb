require 'rails_helper'

describe 'User Validation' do
  it 'requires a username' do
    user = User.new(:username => '')
    user.valid?
    expect(user.errors[:username].any?).to eq true
  end

  it 'requires a email' do
    user = User.new(:email => '')
    user.valid?
    expect(user.errors[:email].any?).to eq true
  end

  it 'requires a password' do
    user = User.new(:password => '')
    user.valid?
    expect(user.errors[:password].any?).to eq true
  end

  it 'accepts a properly formatted email address' do
    emails = %w[user@example.com fist.last@example.com]
    emails.each do |email|
      user = User.new(:email => email)
      user.valid?
      expect(user.errors[:email].any?).to eq false
    end
  end

  it 'rejects a improperly formatted email address' do
    emails = %w[userexample.com userexample user.com user@com]
    emails.each do |email|
      user = User.new(:email => email)
      user.valid?
      expect(user.errors[:email].any?).to eq true
    end
  end

  it 'requires username to be unique' do
    user1 = User.create!(user_attributes)
    user2 = User.new(:username => user1.username)
    user2.valid?
    expect(user2.errors[:username].any?).to eq true
  end

  it 'requires email to be unique' do
    user1 = User.create!(user_attributes)
    user2 = User.new(:email => user1.email)
    user2.valid?
    expect(user2.errors[:email].any?).to eq true
  end

  it 'expects admin to be false by default' do
    user = User.create!(user_attributes)
    expect(user.admin).to eq false
  end

  it '#session' do
    user = User.create!(user_attributes)
    api_key = user.session_api_key
    expect(api_key.access_token).to match(/\S{32}/)
    assert api_key.user_id == user.id
  end

  it 'creates a password_reset_code when user is created' do
    user = User.create!(user_attributes)
    expect(user.password_reset_code).to match(/\S{32}/)
  end
end
