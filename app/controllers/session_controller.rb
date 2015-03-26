class SessionController < ApplicationController
  def create
    user = User.where("username = ? OR email = ?", params[:login], params[:login]).first
    if user && user.authenticate(params[:password])
      render json: {api_key: user.session_api_key, username: user.username}, status: 201
    else
      render json: {}, status: 401
    end
  end
end
