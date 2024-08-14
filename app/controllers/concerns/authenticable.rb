# frozen_string_literal: true

module Authenticable
  # Overriding Devise methods
  def current_user
    byebug
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    unless user_signed_in?
      render json: { errors: 'Not authenticated' }, status: :unauthorized
    end
  end

  def user_signed_in?
    current_user.present?
  end

end