require 'test_helper'

class ProjectControllerTest < ActionController::TestCase
  test "should get title:string" do
    get :title:string
    assert_response :success
  end

  test "should get version:string" do
    get :version:string
    assert_response :success
  end

  test "should get abstract:text" do
    get :abstract:text
    assert_response :success
  end

  test "should get created:datetime" do
    get :created:datetime
    assert_response :success
  end

  test "should get user:references" do
    get :user:references
    assert_response :success
  end

end
