require File.dirname(__FILE__) + '/test_helper'

class ResourcePartyTest < Test::Unit::TestCase
  should "be usable by the masses" do
    assert_not_nil ResourceParty::Base
  end
end