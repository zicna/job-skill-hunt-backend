class ApplicationController < ActionController::API
  respond_to :json
  before_action :process_token
  # * from devise source code
  before_action :configure_permitted_parameters, if: :devise_controller?

    private 

    def process_token
        if request.headers['Authorization'].present?
          begin
            jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.secrets.secret_key_base).first
            @current_user_id = jwt_payload['id']
          rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
            head :unauthorized
          end
        end
    end

    def authenticate_user!(options={})
        head :unauthorized unless signed_in?
    end

    def signed_in?
        @current_user_id.present?
    end

    def current_user
        @current_user ||= super || User.find(@current_user_id)
    end

    protected

    def configure_permitted_parameters
        # byebug
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email])
      end
end
