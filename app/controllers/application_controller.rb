class ApplicationController < ActionController::API
  protected

  def ensure_authenticated_user
    head :unauthorized unless current_user
  end

  def current_user
    api_key = ApiKey.active.where(access_token: token).first
    if api_key
      return api_key.user
    else
      return nil
    end
  end

  def token
    bearer = request.headers["HTTP_AUTHORIZATION"]

    if bearer.present?
      bearer.split.last
    else
      nil
    end
  end
end
