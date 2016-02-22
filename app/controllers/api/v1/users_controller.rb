class Api::V1::UsersController < Api::V1::BaseController

  skip_before_action :require_sign_in, only: [:index, :show]
  skip_before_action :authorize_user, only: [:index, :show]

  def show
    user = User.find(params[:id])
    render json: user.to_json, status: 200
  end

  def index
    users = User.all
    render json: users.to_json, status: 200
  end
end
