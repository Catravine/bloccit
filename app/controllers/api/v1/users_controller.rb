class Api::V1::UsersController < Api::V1::BaseController

  skip_before_action :require_sign_in, only: [:index, :show, :update, :create]
  skip_before_action :authorize_user, only: [:index, :show, :update, :create]
  before_action :authenticate_user

  def show
    if (@current_user.admin?)
      user = User.find(params[:id])
      render json: "[#{user.to_json}]", status: 200
    else
      render json: {error: "Not Authorized", status: 403}, status: 403
    end
  end

  def index
    if (@current_user.admin?)
      users = User.all
      render json: users.to_json, status: 200
    else
      render json: {error: "Not Authorized", status: 403}, status: 403
    end
  end

  def update
    return render json: {error: "Not Authorized", status: 403}, status: 403 unless @current_user.admin?
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      render json: user.to_json, status: 200
    else
      render json: {error: "User update failed", status: 400}, status: 400
    end
  end

  def create
    return render json: {error: "Not Authorized", status: 403}, status: 403 unless @current_user.admin?
    user = User.new(user_params)
    if user.valid?
      user.save!
      render json: user.to_json, status: 201
    else
      render json: {error: "user is invalid", status: 400}, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role)
  end

end
