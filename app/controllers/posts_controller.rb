class PostsController < ApplicationController
  allow_unauthenticated_access

  def index
    @post = BlogPost.published.order(published_at: :desc)
  end

  def show
    @post = BlogPost.published.find_by!(slug: params[:slug])
  end
end
