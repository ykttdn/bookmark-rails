# frozen_string_literal: true

module Api
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'should get me when signed in' do
      alice = users(:alice)
      sign_in alice

      get '/api/users/me'

      assert_response :ok

      json_response = response.parsed_body

      assert_equal json_response['user']['email'], alice.email
    end

    test 'should get unauthorized when not signed in' do
      get '/api/users/me'

      assert_response :unauthorized
    end
  end
end
