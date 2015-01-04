require 'test_helper'

class SupernodesControllerTest < ActionController::TestCase
  setup do
    @supernode = supernodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supernodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supernode" do
    assert_difference('Supernode.count') do
      post :create, supernode: {  }
    end

    assert_redirected_to supernode_path(assigns(:supernode))
  end

  test "should show supernode" do
    get :show, id: @supernode
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @supernode
    assert_response :success
  end

  test "should update supernode" do
    patch :update, id: @supernode, supernode: {  }
    assert_redirected_to supernode_path(assigns(:supernode))
  end

  test "should destroy supernode" do
    assert_difference('Supernode.count', -1) do
      delete :destroy, id: @supernode
    end

    assert_redirected_to supernodes_path
  end
end
