module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      authenticate_request!

      if @current_user
        @current_user
      else
        reject_unauthorized_connection
      end

      @current_user
    end

    # Validates the token and user and sets the @current_user scope
    def authenticate_request!
      app_cookies_key = Rails.application.config.session_options[:key] || raise("No session cookies key in config")

      env["rack.session"] = cookies.encrypted[app_cookies_key]
      @current_user = Warden::SessionSerializer.new(env).fetch(:user)
    end
  end
end
