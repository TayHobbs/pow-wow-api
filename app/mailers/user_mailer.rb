class UserMailer < ApplicationMailer
  def send_forgotten_password_email(user)
    @user = user
    @url  = "https://pow-wow-api.com/user/#{@user.email}/reset-password"
    mail(to: @user.email, subject: 'Pow Wow: Someone requested a password reset on your account')
  end
end
