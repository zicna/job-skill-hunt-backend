class RegistrationsController < Devise::RegistrationsController
    skip_before_action :process_token, only: [:new, :create]


    def create
        byebug

        user = User.new(sign_up_params)

        if user.save
            token = user.generate_jwt
            render jason: token.to_json
        else
            render json: { errors: {'email or password' => ['is invalid'] } }, status: :unprocessable_entity
        end
    end

    
end
