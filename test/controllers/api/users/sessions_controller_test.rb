# frozen_string_literal: true

require 'test_helper'

module Api
  module Users
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = User.create!(email: 'test@example.com', password: 'password123')
      end

      test 'should sign in user with valid credentials' do
        post '/api/sign_in', params: {
          email: @user.email,
          password: @user.password
        }

        assert_response :ok
      end

      test 'should not sign in user with invalid credentials' do
        post '/api/sign_in', params: {
          email: @user.email,
          password: 'wrong_password'
        }

        assert_response :unauthorized

        error = response.parsed_body['errors'].first

        assert_equal 'Invalid email or password.', error
      end
    end
  end
end
