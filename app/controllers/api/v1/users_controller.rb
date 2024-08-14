# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: %i[update destroy]
  respond_to :json

  def show
    render json: current_user
  end

  def create
    user = User.new user_params

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(user_params)
      render json: current_user, status: 200
    else
      render json: { errors: current_user.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :password_confirmation)
  end
end
