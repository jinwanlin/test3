# encoding: utf-8
class UsersController < ApplicationController
  before_filter :login_filter
  before_filter :find_user, only: [:update, :show, :edit, :destroy, :active, :frost, :recharge]
  
  def index
    @users = User
    @users = @users.where(state: params[:state]) if params[:state].present?
    @users = @users.where("name LIKE :query OR phone LIKE :query", query: "%#{params[:query]}%") if params[:query].present?
    @users = @users.order("created_at").reverse_order
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @user.save
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find(params[:id])
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
    payment = Recharge.create(params[:recharge].merge operator: current_user, payer: @user, amount: params[:recharge][:amount])
    redirect_to user_path(@user)
  end
  
  private
  def find_user
    @user = User.find(params[:id])
  end
end
