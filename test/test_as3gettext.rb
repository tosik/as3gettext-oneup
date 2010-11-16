require 'helper'

class TestAs3gettext < Test::Unit::TestCase
  context "-g option" do
    should "generate as3lib" do
      As3gettext::Command.new.run %W(-g test/works)
      assert File.exist?('test/works/_.as')
      assert File.exist?('test/works/com/rails2u/gettext/GetText.as')
    end
  end
end
