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

      test 'should return error on sign in attempt if user is already signed in' do
        sign_in @user
        post '/api/sign_in', params: {
          email: @user.email,
          password: @user.password
        }

        assert_response :forbidden
      end

      test 'should sign out user' do
        sign_in @user

        delete '/api/sign_out'

        assert_response :no_content
        assert_not_predicate @controller, :user_signed_in?
      end

      test 'should not sign out user if not signed in' do
        delete '/api/sign_out'

        assert_response :unauthorized
      end
    end
  end
end
