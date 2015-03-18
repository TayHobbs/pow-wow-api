require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  it "generates an access token" do
    user = User.create!(user_attributes)
    api_key = ApiKey.create(scope: 'session', user_id: user.id)
    expect(api_key.new_record?).to eq false
    expect(api_key.access_token).to match(/\S{32}/)
  end

  it "sets the expired_at properly for 'session' scope" do
    user = User.create!(user_attributes)
    api_key = ApiKey.create(scope: 'session', user_id: user.id)

    expect(api_key.expired_at).to be_within(10.second).of(4.hours.from_now)
  end

  it "sets the expired_at properly for 'api' scope" do
    user = User.create!(user_attributes)
    api_key = ApiKey.create(scope: 'api', user_id: user.id)

    expect(api_key.expired_at).to be_within(10.second).of(30.days.from_now)
  end
end
