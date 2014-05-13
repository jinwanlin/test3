class OrderCountsController < ApplicationController
  # GET /order_counts
  # GET /order_counts.json
  def index
    @order_counts = OrderCount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @order_counts }
    end
  end

  # GET /order_counts/1
  # GET /order_counts/1.json
  def show
    @order_count = OrderCount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order_count }
    end
  end

  # GET /order_counts/new
  # GET /order_counts/new.json
  def new
    @order_count = OrderCount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order_count }
    end
  end

  # GET /order_counts/1/edit
  def edit
    @order_count = OrderCount.find(params[:id])
  end

  # POST /order_counts
  # POST /order_counts.json
  def create
    @order_count = OrderCount.new(params[:order_count])

    respond_to do |format|
      if @order_count.save
        format.html { redirect_to @order_count, notice: 'Order count was successfully created.' }
        format.json { render json: @order_count, status: :created, location: @order_count }
      else
        format.html { render action: "new" }
        format.json { render json: @order_count.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /order_counts/1
  # PUT /order_counts/1.json
  def update
    @order_count = OrderCount.find(params[:id])

    respond_to do |format|
      if @order_count.update_attributes(params[:order_count])
        format.html { redirect_to @order_count, notice: 'Order count was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order_count.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_counts/1
  # DELETE /order_counts/1.json
  def destroy
    @order_count = OrderCount.find(params[:id])
    @order_count.destroy

    respond_to do |format|
      format.html { redirect_to order_counts_url }
      format.json { head :no_content }
    end
  end
end
