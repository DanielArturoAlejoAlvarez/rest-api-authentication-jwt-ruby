class Api::V1::UsersController < ApplicationController

  before_action :authorize_request, except: [:create]
  before_action :set_user, only: [:show,:update,:destroy]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
              status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
              status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private
  def set_user
    @user = User.find_by_username!(params[:_username])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found!' },
            status: :not_found
  end

  def user_params
    params.require(:user).permit(:name,:email,:username,:password,:password_confirmation,:avatar)
  end

end
