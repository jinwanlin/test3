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
  
  def sortable
    params[:type] ||= 'Vegetable'
    @products = Product.where(type: params[:type])
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

  def update_sn
    params[:ids].each_with_index do |id, index| 
      product = Product.find(id)
      product.update_attributes no: index, classify: params[:classify], sn: product.generate_product_sn(index, params[:classify])
    end
    
    render nothing: true
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
  
  def print
    params[:type] ||= 'Vegetable'
    @products = Product.where(type: params[:type])
  end
  
  # get 'to_up'
  # get 'to_down'
  # get 'to_file'
  
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
      # 编号
      sn = product.sn
      p sn
      # 货号
      id = product.id
      content += "PLU	#{sn}	#{id}		3	#{price},#{price_point}	0,0	0,0	#{print_type}	11	0	0	0	0	9	#{product.product_name}								0	0	0	0	0	0	0	0	0	0	0	0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	0	0	0	0	0	0	\n"
    end
    content += "END	PLU \n"
    content += "END	ECS	\n"
    
    send_data content, :type => 'text', :disposition => "attachment; filename=A_xxx.TMS"
  end
  
end
