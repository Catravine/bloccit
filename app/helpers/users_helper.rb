module UsersHelper

  def user_posts(user)
    if user.posts.count == 0
      "<p>#{user.name} has not submitted any posts yet.".html_safe
    else
      render user.posts
    end
  end

    def user_comments(user)
      if user.comments.count == 0
        "<p>#{user.name} has not submitted any comments yet.</p>".html_safe
      else
        render user.comments
      end
    end

end
