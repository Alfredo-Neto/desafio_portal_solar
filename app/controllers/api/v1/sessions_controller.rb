class Api::V1::SessionsController < ApplicationController

  def create
    session = params[:session]
    user_password = session[:password]
    user_email = session[:email]
    user = User.find_by_email(user_email) if user_email

    if user.valid_password? user_password
      sign_in user, store: false
      user.generate_auth_token!
      user.save
      render json: user, status: 200
    else
      render json: { errors: 'Invalid credentials' }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_auth_token!
    user.save
    head 204
  end
end
