class Admin::BlogPostsController < ApplicationController
  def blog_post_params
    permitted = params.require(:blog_post).permit(:title, :excerpt, :cover, :status, :content)
    permitted[:content] = JSON.parse(permitted[:content]) if permitted[:content].present?
    permitted
  end
end