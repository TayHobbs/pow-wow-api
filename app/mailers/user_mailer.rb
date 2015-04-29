class UserMailer < ApplicationMailer
  def send_forgotten_password_email(user)
    @user = user
    @url  = "https://pow-wow-api.com/user/#{@user.email}/reset-password/#{@user.password_reset_code}"
    mail(to: @user.email, subject: 'Pow Wow: Someone requested a password reset on your account')
  end

  def send_reset_password_email(user)
    @user = user
    @login_link = 'localhost:4200/authentication/login'
    mail(to: @user.email, subject: 'Pow Wow: Your password has been reset!')
  end
end
