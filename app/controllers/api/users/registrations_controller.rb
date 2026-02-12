# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < Devise::RegistrationsController
      def create
        super do |resource|
          if resource.persisted?
            if resource.active_for_authentication?
              sign_up(resource_name, resource)
              render json: {}, status: :ok
            else
              expire_data_after_sign_in!
              render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
            end
          else
            clean_up_passwords resource
            set_minimum_password_length
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
          return
        end
      end

      %i[new edit update destroy cancel].each do |action|
        define_method(action) { render status: :not_found }
      end

      protected

      def sign_up_params
        params.expect(registration: [:email, :password, :password_confirmation])
      end
    end
  end
end
