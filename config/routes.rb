# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    devise_for(
      :users, {
        singular: 'user',
        module: 'api/users',
        path: '',
        path_names: { registration: 'sign_up' },
        only: %i[sessions registrations]
      }
    )

    get 'users/me' => 'users#me'
  end
end
