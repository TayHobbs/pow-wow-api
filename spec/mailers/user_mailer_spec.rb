require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { User.create!(user_attributes) }
  let(:mail) { UserMailer.send_forgotten_password_email(user) }

  it 'renders the subject' do
      expect(mail.subject).to eql('Pow Wow: Someone requested a password reset on your account')
  end

  it 'sends to the users email' do
    expect(mail.to).to eql([user.email])
  end

  it 'sends from the correct email' do
    expect(mail.from).to eql(['noreply@powwow.com'])
  end

  it 'includes the users username' do
    expect(mail.body.encoded).to match(user.username)
  end

  it 'includes the reset-password email' do
    expect(mail.body.encoded).to match(
      "https://pow-wow-api.com/user/#{user.email}/reset-password/#{user.password_reset_code}")
  end

end
