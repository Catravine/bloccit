class Api::V1::CommentsController < Api::V1::BaseController

  skip_before_action :require_sign_in, only: [:index, :show]
  skip_before_action :authorize_user, only: [:index, :show]

  def index
    comments = Comment.all
    render json: posts.to_json, status: 200
  end

  def show
    comment = Comment.find(params[:id])
    render json: post.to_json, status: 200
  end
end
