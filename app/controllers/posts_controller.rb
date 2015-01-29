class PostsController < ApplicationController

  before_action :set_post, only:[:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @post = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    
    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path 
    else
      render :new
    end

  end

  def edit

    if current_user != @post.creator
      flash[:error] = "You do not have permission to edit this post."
      redirect_to root_path
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "This post was updated."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html {
        if @vote.valid?
          flash[:notice] = "Voted."
        else
          flash[:error] = @vote.errors.full_messages.first
        end
        redirect_to :back
      }
      format.js {}
    end



  end


  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
