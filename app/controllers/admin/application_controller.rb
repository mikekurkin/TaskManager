class Admin::ApplicationController < ApplicationController
  include AuthHelper
  before_action :authenticate_user!, :authorize
  helper_method :current_user

  def authorize
    render(file: Rails.public_path.join('403.html'), status: :forbidden, layout: false) if forbidden?
  end

  def forbidden?
    !current_user.is_a?(Admin)
  end
end
