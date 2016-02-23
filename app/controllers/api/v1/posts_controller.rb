class Api::V1::PostsController < Api::V1::BaseController

  skip_before_action :require_sign_in, only: [:index, :show]
  skip_before_action :authorize_user, only: [:index, :show]

  def index
    posts = Post.all
    render json: posts.to_json, status: 200
  end

  def show
    post = Post.find(params[:id])
    response = "#{post.to_json} \n\n #{post.comments.to_json}"
    render json: response, status: 200
  end
end
