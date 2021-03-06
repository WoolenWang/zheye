class UsersController < ApplicationController
  authorize_resource :except => [:cur_user, :all_questions, :all_answers, :all_comments, :all_upvotes, :all_downvotes]

  respond_to :html, :js
  # Display all users
  # Require admin access
  def index

  end
  # Action: Create a new user
  # params.require(:user).permit(:login, :password, :password_confirmation)
  def create
    @user = User.new(users_params)
    @user.admin = @user.login == 'admin'
    @user.save
  end

  # Display registration form
  def new
    @user = User.new
    render 'new', layout: 'simple'
  end

  # Display info about certain user
  def show
    @user = User.find(params[:id])
  end

  # Display form to edit current user's info
  def edit
    @user = User.find(params[:id])
  end

  # Action: Update given user's infos
  def update
    @user = User.find(params[:id])
    if @user.update(user_info_params)
      redirect_to @user
    else
      render 'edit'
    end

  end

  def cur_user
    redirect_to current_user
  end

  def all_questions
    @user = User.find(params[:id])
    @questions = @user.questions
    authorize! :read, Question
  end

  def all_answers
    @user = User.find(params[:id])
    @answers = @user.answers
    authorize! :read, Answer
  end

  def all_comments
    @user = User.find(params[:id])
    @comments = @user.comments
    authorize! :read, Comment
  end

  def all_upvotes
    @user = User.find(params[:id])
    @upvotes = Vote.where({user: @user, attitude: 1})
    authorize! :read, Vote
  end

  def all_downvotes
    @user = User.find(params[:id])
    @downvotes = Vote.where({user: @user, attitude: -1})
  end

  # Action: Destroy certain user(not logout)
  # Require admin access
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  private

  def users_params
    # Todo: Add other user info required by register here
    params.require(:user).permit(:login, :password, :password_confirmation)
  end

  def user_info_params
    params.require(:user).permit(:gender, :realname, :birthday, :address, :self_introduction)
  end

end
