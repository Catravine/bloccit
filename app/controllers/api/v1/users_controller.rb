class Api::V1::UsersController < Api::V1::BaseController

  skip_before_action :require_sign_in, only: [:index, :show]
  skip_before_action :authorize_user, only: [:index, :show]
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
  
end
