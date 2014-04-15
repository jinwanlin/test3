# encoding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource class: 'User'
  
  before_filter :find_user, only: [:show, :edit, :update, :destroy, :active, :frost, :recharge]
  
  def index
    @users = User
    @users = @users.where(state: params[:state]) if params[:state].present?
    @users = @users.where("name LIKE :query OR phone LIKE :query", query: "%#{params[:query]}%") if params[:query].present?
    @users = @users.order("created_at").reverse_order
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])
    @user.save
  end

  def update
    @user.update_attributes(params[:user])

    respond_to do |format|
      format.html {redirect_to user_path(@user)}
      format.js { render nothing: true }
    end
    
    
  end

  def destroy
    @user.destroy
    redirect_to users_url
  end
  
  def active
    @user.active
    redirect_to users_url
  end
  
  def frost
    @user.frost
    redirect_to users_url
  end
  
  # 充值
  def recharge
    payment = Recharge.create(params[:payment].merge operator: current_user, payer: @user)
    redirect_to user_path(@user)
  end
  
  private
  def find_user
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
end
