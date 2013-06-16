require 'test_helper'

class VisitorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "create pass id" do 
    visitor = Visitor.new
    visitor.set_pass_id
    assert_not_nil( visitor.set_pass_id, "pass not nil " + visitor.pass_id )
  end
end
