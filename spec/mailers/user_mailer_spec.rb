require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user)           { User.create!(user_attributes) }
  let(:forgotten_mail) { UserMailer.send_forgotten_password_email(user) }
  let(:reset_mail)     { UserMailer.send_reset_password_email(user) }

  it 'renders the subject in forgotten email' do
      expect(forgotten_mail.subject).to eql('Pow Wow: Someone requested a password reset on your account')
  end

  it 'sends to the users email in forgotten email' do
    expect(forgotten_mail.to).to eql([user.email])
  end

  it 'sends from the correct email in forgotten email' do
    expect(forgotten_mail.from).to eql(['noreply@powwow.com'])
  end

  it 'includes the users username in forgotten email' do
    expect(forgotten_mail.body.encoded).to match(user.username)
  end

  it 'includes the reset-password email in forgotten email' do
    expect(forgotten_mail.body.encoded).to match(
      "https://pow-wow-api.com/user/#{user.email}/reset-password/#{user.password_reset_code}")
  end

  it 'renders the subject in reset email' do
      expect(reset_mail.subject).to eql('Pow Wow: Your password has been reset!')
  end

  it 'sends to the users email in reset email' do
    expect(reset_mail.to).to eql([user.email])
  end

  it 'sends from the correct email in reset email' do
    expect(reset_mail.from).to eql(['noreply@powwow.com'])
  end

  it 'includes the users username in reset email' do
    expect(reset_mail.body.encoded).to match(user.username)
  end

  it 'includes the users new password in reset email' do
    expect(reset_mail.body.encoded).to match(user.password)
  end

  it 'includes the login link in reset email' do
    expect(reset_mail.body.encoded).to match('localhost:4200/authentication/login')
  end

end
