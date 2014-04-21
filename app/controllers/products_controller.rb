# encoding: utf-8
class ProductsController < ApplicationController
  load_and_authorize_resource class: 'Product'
  # skip_before_filter :authenticate_user!, only: :search
  
  before_filter :find_product, only: [:update, :show, :edit, :destroy, :to_up, :to_down, :to_file, :change_type]
  
  
  def index
        date = Date.today
        date = date-1.days if Time.new.hour < 3 # 凌晨3点前任然显示昨天的价格
      
        # @products = Product.order(:id)
        # @products = @products.where(type: params[:type]) if params[:type].present?
      
        @predicts = find_predicts(date, current_user)
        if @predicts.empty? && !params[:searchKey].present?
          Predict.update_user current_user
          @predicts = find_predicts(date, current_user)
        end
      
        if params[:searchKey].present?
            SearchHistory.where(keywords: params[:searchKey], user_id: current_user).delete_all
            @search_history = SearchHistory.create keywords: params[:searchKey], user: current_user, has_result: (@predicts.size>0 ? "true" : "false")
        end
    
      @last_order = current_user.orders.where(state: ['pending', 'confirmed']).first if current_user
      render layout: "products_layout"
    
  end
  
  
  def find_predicts(date, user)
    @predicts = Predict.where(user_id: user).where(date: date)
    @predicts = @predicts.joins(:product).where("products.type = ?", params[:type]) if params[:type].present?
    @predicts = @predicts.joins(:product).where("products.classify = ?", params[:classify]) if params[:classify].present?
    @predicts = @predicts.joins(:product).where("products.name like ?", "%#{params[:searchKey]}%") if params[:searchKey].present?
    
    params[:order] ||= 'bought'
    if params[:order] == 'pinyin'
      @predicts = @predicts.joins(:product).order("products.pinyin")
    elsif params[:order] == 'price_asc'
      @predicts = @predicts.joins(:product).order("products.cost")
    elsif params[:order] == 'price_desc'
      @predicts = @predicts.joins(:product).order("products.cost DESC")
    else #bought
      @predicts = @predicts.joins(:product).order("order_times DESC").order("products.pinyin")
    end
    @predicts
  end
  
  def user_buy_list_print
    @user = User.find(params[:user_id])
    
    @predicts = find_predicts(Date.today, @user)
    if @predicts.empty?
      Predict.update_user user
      @predicts = find_predicts(date, @user)
    end
  end
  
  
  
  def list
    params[:type] ||= 'Vegetable'
    @states = params[:state] || ['up', 'down']
    
    @products = Product.where("state in (?)", @states)
    @products = @products.where(type: params[:type]) if params[:type].present?
    @products = @products.where(optional_amounts: params[:optional_amounts]) if params[:optional_amounts].present?
    @products = @products.order("pinyin") #.paginate(:page => @page, :per_page => 5)
  end
  
  def sortable
    params[:type] ||= 'Vegetable'
    @products = Product.where(type: params[:type]).where(state: 'up')
  end
  
  def sortable_print
    params[:type] ||= 'Vegetable'
    @products = Product.where(type: params[:type]).where("state in (?)", ['up', 'down']).order("pinyin")
  end
  
  
  def sortable_market
    params[:type] ||= 'Vegetable'
    @products = Product.where(type: params[:type]).where(state: 'up')
    Product.do_order_total
  end
  
  def print_dm
    @products = Product.where(type: 'Vegetable').where(state: 'up')
    render layout: "print"
  end

  def show
  end

  def new
    @product = Vegetable.new
  end

  def edit
  end

  def create
    if params[:amounts].present?
      params[:product][:amounts] = params[:amounts].gsub(' ', '').split(",") 
    else
      params[:product][:amounts] = nil
    end
    @product = Product.new(params[:product])
    @product.attachments << Attachment.new(:source => params[:attachment]) unless params[:attachment].blank?
    if @product.save
      redirect_to @product
    else
      render action: "new"
    end
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
  
  def change_price
    # http://lvh.me:3000/products/97/change_price?price_name=price_1&function=minus
    
    @product = Product.find(params[:id])
    if params[:price_name] == 'price_1'
      if params[:function] == 'plus'
        @product.price_1 = @product.price_1+0.05
      elsif params[:function] == 'minus'
        @product.price_1 = @product.price_1-0.05
      end
    elsif params[:price_name] == 'price_2'
      if params[:function] == 'plus'
        @product.price_2 = @product.price_2+0.05
      elsif params[:function] == 'minus'
        @product.price_2 = @product.price_2-0.05
      end
    elsif params[:price_name] == 'price_3'
      if params[:function] == 'plus'
        @product.price_3 = @product.price_3+0.05
      elsif params[:function] == 'minus'
        @product.price_3 = @product.price_3-0.05
      end
    end
    @product.save
    
    
  end
  
  def update_product
    @product.update_attributes(params[:product])
    render nothing: true
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
    products = products.where("name LIKE :query OR aliases LIKE :query", query: "%#{params[:query]}%")
    
    names = Array.new
    products.each do |product|
      names << product.product_name
    end
    render :json =>  names.to_s
  end
  
  def to_up
    @product.to_up

    today = Date.today
    User.all.each do |user|
      order_ids = Order.where(user_id: user).where(:state => ['shiping', 'baled', 'truck', 'signed', 'done']).where("created_at > ?", today-8.days).where("created_at < ?", today+1.days).pluck(:id)
      Predict.update_product_user(user, today, order_ids, @product)
    end
  end
  
  def to_down
    @product.to_down
    Predict.where(product_id: @product, order_amount: 0).delete_all
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
        content += "PLU	#{id}	#{id}		3	#{price},#{price_point}	0,0	0,0	#{print_type}	11	0	0	0	0	9	#{product.product_name}								0	0	0	0	0	0	0	0	0	0	0	0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	127	0,0	0,0	0,0	0	0	0	0	0	0	0	\n"
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
