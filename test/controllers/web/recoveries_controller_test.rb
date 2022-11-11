require 'test_helper'

class Web::RecoveriesControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create' do
    user = create(:user)
    assert_emails 1 do
      post :create, params: { new_recovery_form: { email: user.email } }
    end
    assert_response :redirect
    assert_predicate flash[:alert], :nil?
  end

  test 'should get show' do
    user = create(:user)
    token = user.new_recovery_token
    get :show, params: { token: token }
    assert_response :success
  end

  test 'should patch update' do
    user = create(:user)
    token = user.new_recovery_token
    new_password = generate(:password)
    patch :update, params: { recovery_form: { token: token, password: new_password, password_confirmation: new_password } }
    assert_response :redirect
    assert_predicate flash[:alert], :nil?
  end
end
