require 'test_helper'

class OrderCountsControllerTest < ActionController::TestCase
  setup do
    @order_count = order_counts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_counts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_count" do
    assert_difference('OrderCount.count') do
      post :create, order_count: { date: @order_count.date, product: @order_count.product }
    end

    assert_redirected_to order_count_path(assigns(:order_count))
  end

  test "should show order_count" do
    get :show, id: @order_count
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_count
    assert_response :success
  end

  test "should update order_count" do
    put :update, id: @order_count, order_count: { date: @order_count.date, product: @order_count.product }
    assert_redirected_to order_count_path(assigns(:order_count))
  end

  test "should destroy order_count" do
    assert_difference('OrderCount.count', -1) do
      delete :destroy, id: @order_count
    end

    assert_redirected_to order_counts_path
  end
end
