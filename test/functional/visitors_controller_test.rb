require 'test_helper'

class VisitorsControllerTest < ActionController::TestCase
  setup do
    @visitor = visitors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visitors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visitor" do
    assert_difference('Visitor.count') do
      post :create, visitor: { authorized_id: @visitor.authorized_id, comment: @visitor.comment, here_to_meet: @visitor.here_to_meet, location: @visitor.location, reason_to_visit: @visitor.reason_to_visit, storage_device_detail: @visitor.storage_device_detail, user_id: @visitor.user_id, visitor_company_name: @visitor.visitor_company_name, visitor_mobile_number: @visitor.visitor_mobile_number, visitor_name: @visitor.visitor_name, visitor_vehicle_number: @visitor.visitor_vehicle_number }
    end

    assert_redirected_to visitor_path(assigns(:visitor))
  end

  test "should show visitor" do
    get :show, id: @visitor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @visitor
    assert_response :success
  end

  test "should update visitor" do
    put :update, id: @visitor, visitor: { authorized_id: @visitor.authorized_id, comment: @visitor.comment, here_to_meet: @visitor.here_to_meet, location: @visitor.location, reason_to_visit: @visitor.reason_to_visit, storage_device_detail: @visitor.storage_device_detail, user_id: @visitor.user_id, visitor_company_name: @visitor.visitor_company_name, visitor_mobile_number: @visitor.visitor_mobile_number, visitor_name: @visitor.visitor_name, visitor_vehicle_number: @visitor.visitor_vehicle_number }
    assert_redirected_to visitor_path(assigns(:visitor))
  end

  test "should destroy visitor" do
    assert_difference('Visitor.count', -1) do
      delete :destroy, id: @visitor
    end

    assert_redirected_to visitors_path
  end
end
