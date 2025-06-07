module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.user ||= find_user_by_cookie
    end

    def find_user_by_cookie
      user_id = cookies.signed[:user_id]
      User.find_by(id: user_id) if user_id
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user)
      Current.user = user
      cookies.signed.permanent[:user_id] = { value: user.id, httponly: true, same_site: :lax }
    end

    def terminate_session
      Current.user = nil
      cookies.delete(:user_id)
    end
end
