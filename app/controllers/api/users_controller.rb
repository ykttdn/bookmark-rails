# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    def me
      if user_signed_in?
        render json: { user: { email: current_user.email } }
      else
        render json: { user: nil }, status: :unauthorized
      end
    end
  end
end
