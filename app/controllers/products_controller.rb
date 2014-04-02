# encoding: utf-8
class ProductsController < ApplicationController
  load_and_authorize_resource class: 'Product'
  
  before_filter :find_product, only: [:update, :show, :edit, :destroy, :to_up, :to_down, :to_file]
  
  def index
    params[:type] ||= 'Vegetable'
    @page = params[:page] ||= 1
    @products = Product.where("state in (?)", ['up', 'down'])
    @products = @products.where(type: params[:type]) if params[:type].present?
    @products = @products.order("state desc") #.paginate(:page => @page, :per_page => 5)
    @order = current_user.orders.where(state: ['pending', 'confirmed']).first if current_user
  end
  
  def sortable
    params[:type] ||= 'Vegetable'
    @products = Product.where(type: params[:type]).where(state: 'up')
  end
  
  def sortable_market
    params[:type] ||= 'Vegetable'
    @products = Product.where(type: params[:type]).where(state: 'up')
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    if params[:amounts].present?
      params[:product][:amounts] = params[:amounts].gsub(' ', '').split(",") 
    else
      params[:product][:amounts] = nil
    end
    @product.attachments << Attachment.new(:source => params[:attachment]) unless params[:attachment].blank?
    @product = Product.new(options: params[:product])
    @product.save
    
    redirect_to @product
  end

  def update
    if params[:amounts].present?
      params[:product][:amounts] = params[:amounts].gsub(' ', '').split(",") 
    else
      params[:product][:amounts] = nil
    end
    @product.update_attributes(params[:product])
    
    redirect_to @product
  end
  
  def upload_file
    @product = Product.find(params[:id])
    @product.attachments << Attachment.new(:source => params[:attachment]) unless params[:attachment].blank?
    @product.save
    redirect_to @product
  end
  
  def delete_attachment
    @product = Product.find(params[:id])
    @product.attachments.delete(Attachment.find(params[:attachment_id]))
    @product.save
    redirect_to edit_product_path(@product)
  end

  def update_sn
    if params[:ids].present?
      params[:ids].each_with_index do |id, index| 
        product = Product.find(id)
        product.update_attributes no: (index+1), classify: params[:classify], sn: product.generate_product_sn(index, params[:classify])
      end
    end
    render nothing: true
  end
  
  def update_market
    p params[:ids]
    p params[:market_area]
    if params[:ids].present?
      params[:ids].each_with_index do |id, index| 
        product = Product.find(id)
        product.update_attributes market_sort: index, market_area: params[:market_area]
      end
    end
    render nothing: true
  end
  
  def destroy
    @product.destroy
  end
  
  def search
    products = Product.where(type: 'Vegetable', state: 'up')
    products = products.where("name LIKE ?", "%#{params[:query]}%")
    names = Array.new
    products.each do |product|
      names << product.product_name
    end
    # products.pluck(:product_name).compact.to_s
    render :json =>  names.to_s
  end
  
  def to_up
    @product.to_up
  end
  
  def to_down
    @product.to_down
  end
  
  def to_file
    @product.to_file
  end
  
  def export
    # 打印类型
    print_type = 10
    # 单价，分为单位
    price = "200"
    # 单价小数位数
    price_point = "2"
    
    content = "ECS	VER	100	\n"
    content += "DWL	PLU	\n"
    Vegetable.where("classify is not null").each do |product|
      
      sn = product.sn # 编号
      id = product.id # 货号
      if sn != ""
        content += "PLU	#{sn}	#{id}		3	#{price},#{price_point}	0,0	0,0	#{print_type}	11	0	0	0	0	9	#{product.product_name}								0	0	0	0	0	0	0	0	0	0	0	0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	0	0	0	0	0	0	\n"
      end
    end
    content += "END	PLU \n"
    content += "END	ECS	\n"
    
    send_data content, :type => 'text', :disposition => "attachment; filename=A_xxx.TMS"
  end
  
  private
  def find_product
    @product = Product.find(params[:id])
  end
  
end
