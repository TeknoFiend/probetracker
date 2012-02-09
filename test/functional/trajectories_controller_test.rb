require 'test_helper'

class TrajectoriesControllerTest < ActionController::TestCase
  setup do
    @trajectory = trajectories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trajectories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trajectory" do
    assert_difference('Trajectory.count') do
      post :create, trajectory: @trajectory.attributes
    end

    assert_redirected_to trajectory_path(assigns(:trajectory))
  end

  test "should show trajectory" do
    get :show, id: @trajectory.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trajectory.to_param
    assert_response :success
  end

  test "should update trajectory" do
    put :update, id: @trajectory.to_param, trajectory: @trajectory.attributes
    assert_redirected_to trajectory_path(assigns(:trajectory))
  end

  test "should destroy trajectory" do
    assert_difference('Trajectory.count', -1) do
      delete :destroy, id: @trajectory.to_param
    end

    assert_redirected_to trajectories_path
  end
end
