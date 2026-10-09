class Admin::BlogPostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy publish unpublish]

  def index
    @posts = BlogPost.order(created_at: :desc)
  end

  def new
    @post = BlogPost.new
  end

  def create
    @post = BlogPost.new(post_params)
    if @post.save
      redirect_to admin_blog_posts_path, notice: 'Article créé.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to admin_blog_posts_path, notice: 'Article mis à jour.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_blog_posts_path, notice: 'Article supprimé.'
  end

  def publish
    @post.publish!
    redirect_to admin_blog_posts_path, notice: 'Article publié.'
  rescue AASM::InvalidTransition
    redirect_to admin_blog_posts_path, notice: 'Publication impossible (contenu vide ?)'
  end

  def unpublish
    @post.unpublish!
    redirect_to admin_blog_posts_path, notice: "Article repassé en brouillon."
  end

  private

  def set_post = BlogPost.find(params[:id])

  def post_params
    params.require(:blog_post).permit(:title, :slug, :excerpt, :content, :cover)
  end
end