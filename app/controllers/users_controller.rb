class UsersController < ApplicationController
  before_filter :ensure_authenticated_user, only: [:index, :show, :destroy]
  before_action :get_user, only: [:show, :destroy, :update]

  def index
    if current_user.admin?
      render json: User.all
    else
      render json: { error: "You do not have the proper access to view this page." }, status: 403
    end
  end

  def show
    render json: @user
  end

  def create
    user = User.create(user_params)
    if user.new_record?
      render json: { errors: user.errors.messages }, status: 422
    else
      render json: user
    end
  end

  def destroy
    if @user.access_token_matches?(request.headers["HTTP_AUTHORIZATION"])
      if @user.destroy
        render json: {}, status: 200
      end
    else
      render json: { error: 'You can only delete your own account!' }, status: 403
    end
  end

  def update
    if @user.access_token_matches?(request.headers["HTTP_AUTHORIZATION"]) or (current_user and current_user.admin?)
      if @user.update(user_params)
        render json: @user
      end
    else
      render json: { error: 'You can only edit your own account!' }, status: 403
    end
  end

  def forgotten_password
    user = User.find_by(:email => params[:email])
    UserMailer.send_forgotten_password_email(user).deliver_now
  end

  def reset_password
    user = User.find_by(:email => params[:email])
    user.reset_password(params[:reset_code])
  end

  private

  def get_user
    @user = User.find_by(:id => params[:id])
    unless @user
      render json: { error: 'This account doesn\'t exist!' }
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin)
  end
end
