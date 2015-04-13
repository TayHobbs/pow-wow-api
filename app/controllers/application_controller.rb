class ApplicationController < ActionController::API
  protected

  def ensure_authenticated_user
    head :unauthorized unless current_user
  end

  def current_user
    unless api_key = ApiKey.active.where(access_token: token).first
      api_key = reauthenticate
    end

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

  def reauthenticate
    if request.headers['HTTP_REFRESH'] and api_key = ApiKey.where(refresh_token: request.headers['HTTP_REFRESH']).first
      user = api_key.user
      user.generate_new_access_token
      user.session_api_key
    end
  end

end
