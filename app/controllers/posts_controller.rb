class PostsController < ApplicationController
  def index
    @posts = Post.all
    censor
  end

  def show
    censor
  end

  def new
    censor
  end

  def edit
    censor
  end

  def censor
    @posts.each_with_index do |post, index|
      if (index % 5 == 0)
        post.update title: "SPAM"
        post.save!
      end
    end
  end
end
