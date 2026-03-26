# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  class_methods do
    def unauthenticated_access_only(**option)
      before_action(
        lambda {
          return unless current_user

          render json: { errors: [I18n.t('devise.failure.already_authenticated')] }, status: :forbidden
        },
        **option
      )
    end
  end
end
