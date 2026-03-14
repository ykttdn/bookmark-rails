# frozen_string_literal: true

module Api
  module Users
    class SessionsController < Devise::SessionsController
      def create
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          sign_in(:user, user)
          render status: :ok
        else
          render json: { errors: [I18n.t('devise.failure.not_found_in_database', authentication_keys: :email)] },
                 status: :unauthorized
        end
      end
    end
  end
end
