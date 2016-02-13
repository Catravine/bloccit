class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    @topic_id = params[:topic_id]
    if params[:post_id]
      @parent = Post.find(params[:post_id])
      redirect_route = "/topics/1/posts/#{params[:post_id]}"
    else
      @parent = Topic.find(params[:topic_id])
      redirect_route = "/topics/#{params[:topic_id]}"
    end

    comment = @parent.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      flash[:notice] = "Comment saved successfully."
      redirect_to redirect_route
    else
      flash[:alert] = "Comment failed to save."
      redirect_to redirect_route
    end
  end

  def destroy
    if params[:post_id]
      @parent = Post.find(params[:post_id])
      redirect_route = "/topics/1/posts/#{params[:post_id]}"
    else
      @parent = Topic.find(params[:topic_id])
      redirect_route = "/topics/#{params[:topic_id]}"
    end
    comment = @parent.comments.find(params[:id])

    if comment.destroy
      flash[:notice] = "Comment was deleted."
      redirect_to redirect_route
    else
      flash[:alert] = "Comment couln't be deleted.  Try again."
      redirect_to redirect_route
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    comment = Comment.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = "You do not have permission to delete a comment."
      redirect_to [comment.post.topic, comment.post]
    end
  end

end
