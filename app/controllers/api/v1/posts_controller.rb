class Api::V1::PostsController < Api::V1::BaseController

  skip_before_action :require_sign_in, only: [:index, :show, :update, :create, :destroy]
  skip_before_action :authorize_user
  before_action :authenticate_user, except: [:index, :show]

  def index
    posts = Post.all
    render json: posts.to_json, status: 200
  end

  def show
    post = Post.find(params[:id])
    render json: post.to_json, status: 200
  end

  def update
    return render json: {error: "Not Authorized", status: 403}, status: 403 unless @current_user.admin?
    post = Post.find(params[:id])
    if post.update_attributes(post_params)
      render json: post.to_json, status: 200
    else
      render json: {error: "Post update failed", status: 400}, status: 400
    end
  end

  def destroy
    return render json: {error: "Not Authorized", status: 403}, status: 403 unless @current_user.admin?
    post = Post.find(params[:id])
    if post.destroy
      render json: {message: "Post destroyed",  status: 200}, status: 200
    else
      render json: {error: "Post destroy failed", status: 400}, status: 400
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :topic, :user)
  end

end
