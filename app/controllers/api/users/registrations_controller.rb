# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < Devise::RegistrationsController
      include Authentication

      unauthenticated_access_only only: :create

      def create
        user = User.new(sign_up_params)

        if user.save
          if user.active_for_authentication?
            sign_in(user)
            render status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_content
          end
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_content
        end
      end

      %i[new edit update destroy cancel].each do |action|
        define_method(action) { render status: :not_found }
      end

      private

      def sign_up_params
        params.expect(registration: %i[email password password_confirmation])
      end
    end
  end
end
