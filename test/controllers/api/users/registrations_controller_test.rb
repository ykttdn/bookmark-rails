# frozen_string_literal: true

require 'test_helper'

class Api::Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_params = {
      registration: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end

  test 'should create user with valid params' do
    assert_difference('User.count') do
      post '/api/sign_up', params: @user_params
    end

    assert_response :ok
  end

  test 'should not create user with invalid email' do
    invalid_params = {
      registration: {
        email: 'invalid-email',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }

    assert_no_difference('User.count') do
      post '/api/sign_up', params: invalid_params
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(@response.body)
    assert_includes json_response['errors'], 'Email is invalid'
  end

  test 'should not create user with password mismatch' do
    mismatched_params = {
      registration: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'different123'
      }
    }

    assert_no_difference('User.count') do
      post '/api/sign_up', params: mismatched_params
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(@response.body)
    assert_includes json_response['errors'], "Password confirmation doesn't match Password"
  end

  test 'should not create user with duplicate email' do
    User.create!(email: 'test@example.com', password: 'password123')

    assert_no_difference('User.count') do
      post '/api/sign_up', params: @user_params
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(@response.body)
    assert_includes json_response['errors'], 'Email has already been taken'
  end

  test 'should sign in user after registration' do
    post '/api/sign_up', params: @user_params

    assert_response :ok
    assert_not_nil cookies['_bookmark_rails_session']
  end
end
