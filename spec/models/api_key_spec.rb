require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  it 'generates an access token' do
    user = User.create!(user_attributes)
    api_key = ApiKey.create(user_id: user.id)
    expect(api_key.new_record?).to eq false
    expect(api_key.access_token).to match(/\S{32}/)
  end

  it 'sets the expired_at properly' do
    user = User.create!(user_attributes)
    api_key = ApiKey.create(user_id: user.id)

    expect(api_key.expired_at).to be_within(10.second).of(4.hours.from_now)
  end

  it 'generates an refresh token' do
    user = User.create!(user_attributes)
    api_key = ApiKey.create(user_id: user.id)
    expect(api_key.new_record?).to eq false
    expect(api_key.refresh_token).to match(/\S{32}/)
  end

end
