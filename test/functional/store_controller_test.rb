require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', :minimum => 4 
    assert_select '#main .entry', :minimum => 3 #attempts to select three #main elements with a .entry child
    assert_select 'h3', 'Programming Ruby 1.9' 
    assert_select '.price', /\$[,\d]+\.\d\d/ #attempts to select a formatted currency digit
  end

end
