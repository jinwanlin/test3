# encoding: utf-8
class ProductsController < ApplicationController
  
  def index
    params[:type] ||= 'Vegetable'
    @page = params[:page] ||= 1
    @products = Product
    @products = @products.where(type: params[:type]) if params[:type].present?
    @products = @products.order("updated_at") #.paginate(:page => @page, :per_page => 5)
    @order = current_user.orders.where(state: ['pending', 'open']).first if current_user
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    if params[:amounts].present?
      params[:product][:amounts] = params[:amounts].gsub(' ', '').split(",") 
    else
      params[:product][:amounts] = nil
    end
    @product = Product.new(options: params[:product])
    @product.save
  end

  def update
    @product = Product.find(params[:id])
    if params[:amounts].present?
      params[:product][:amounts] = params[:amounts].gsub(' ', '').split(",") 
    else
      params[:product][:amounts] = nil
    end

    @product.update_attributes(params[:product])
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
  end
  
  def search
    products = Product.where(type: 'Vegetable')
    products = products.where("name LIKE ?", "%#{params[:query]}%")
    render :json =>  products.pluck(:name).compact.to_s
  end
  
  def to_up
    
  end
  
  # get 'to_up'
  # get 'to_down'
  # get 'to_file'
  
  def export
    content = "ECS	VER	100	\n"
    content += "DWL	PLU	\n"
    Vegetable.all.each do |product|
      content += "PLU	#{product.sn}	#{product.sn}		7	15,1	0,0	0,0	11	10	0	0	0	0	9	#{product.product_name}								0	0	0	0	0	0	0	0	0	0	0	0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	0	0	0	0	0	0	\n"
    end
    content += "END	PLU \n"
    content += "END	ECS	\n"
    
    send_data content, :type => 'text', :disposition => "attachment; filename=A_xxx.TMS"
  end
  
end
