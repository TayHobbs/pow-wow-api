class UsersController < ApplicationController
  before_filter :ensure_authenticated_user, only: [:index, :show, :destroy]
  before_action :get_user, only: [:show, :destroy]

  def index
    render json: User.all
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
        render json: { message: 'Account successfully deleted!' }
      end
    else
      render json: { error: 'You can only delete your own account!' }
    end
  end

  private

  def get_user
    @user = User.find_by(:id => params[:id])
    unless @user
      render json: { error: 'This account doesn\'t exist!' }
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
