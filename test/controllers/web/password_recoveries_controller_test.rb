require 'test_helper'

class Web::PasswordRecoveriesControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create' do
    user = create(:user)
    assert_emails 1 do
      post :create, params: { new_password_recovery_form: { email: user.email } }
    end
    assert_response :redirect
    assert_predicate flash[:alert], :nil?
  end

  test 'should get show' do
    user = create(:user)
    token = PasswordRecoveryService.new_token(user)
    get :show, params: { token: token }
    assert_response :success
  end

  test 'should patch update' do
    user = create(:user)
    token = PasswordRecoveryService.new_token(user)
    new_password = generate(:password)
    patch :update, params: { password_recovery_form: { token: token, password: new_password, password_confirmation: new_password } }
    assert_response :redirect
    assert_predicate flash[:alert], :nil?
  end
end
