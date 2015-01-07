require 'test_helper'

class TestCaseTest < Cell::TestCase
  include ActiveSupport::Testing::Deprecation

  class << self # FIXME: why use Minitest::Spec syntax here. how does C::TC work with that?
    alias_method :before, :setup
    alias_method :it, :test

    def describe(msg, &block)
      instance_exec &block
    end
  end

  before do
    @test = Cell::TestCase.new(:cell_test)

    BassistCell.class_eval do
      def play; render; end
    end
  end

  describe "#render_cell" do
    it "invokes the state" do
      assert_equal "Doo", render_cell(:bassist, :play)
    end

    it "accept state args" do
      assert_equal "*shouts* Listen!\n", render_cell(:bassist, :shout, :words => "Listen!")
    end
  end

  it "respond to #assert_selector with 3 args" do
    assert_selector "p", "Doo", "<p>Doo</p>y"
  end

  describe "#cell" do
    it "create a cell" do
      assert_kind_of BassistCell, cell(:bassist)
    end

    it "accept a block" do
      assert_respond_to cell(:bassist){ def whatever; end }, :whatever
    end
  end

  describe "#subject_cell" do
    it "return the last rendered cell" do
      render_cell(:bassist, :play)
      assert_kind_of BassistCell, subject_cell
    end
  end


  describe "#view_assigns" do
    it "be emtpy when nothing was set" do
      render_cell(:bassist, :play)
      if Cell.rails_version.~("3.0")
        assert_equal([:lookup_context], view_assigns.keys)
      else
        assert_equal({}, view_assigns)
      end
    end

    it "return the instance variables from the last #render_cell" do
      BassistCell.class_eval do
        def sleep
          @duration = "8h"
        end
      end
      render_cell(:bassist, :sleep)
      if Cell.rails_version.~("3.0")
        assert_equal("8h", view_assigns[:duration])
      else
        assert_equal({:duration => "8h"}, view_assigns)
      end
    end
  end

  describe "in declarative tests" do
    it "respond to TestCase.tests" do
      self.class.tests BassistCell
      assert_equal BassistCell, self.class.controller_class
    end

    it "infer the cell name" do
      class SingerCell < Cell::Rails
      end

      class SingerCellTest < Cell::TestCase
      end

      assert_equal SingerCell, SingerCellTest.new(:cell_test).class.controller_class
    end

    describe "with #invoke" do
      before do
        self.class.tests BassistCell
      end

      it "provide #invoke" do
        assert_equal "Doo", invoke(:play)
      end

      it "provide #last_invoke" do
        assert_equal nil, last_invoke
        assert_equal "Doo", invoke(:play)
        assert_equal "Doo", last_invoke
      end

      it "provide #invoke accepting options" do
        #assert_equal "Doo", invoke(:play)
      end

      it "provide #invoke accepting args" do
        assert_equal "*shouts* Listen!\n", invoke(:shout, :words => "Listen!")
      end

      it "provide assert_select" do
        invoke :promote
        assert_select "a", "vd.com"
      end
    end

    describe "#before_test_states_in" do
      it "add the :in_view state" do
        c = cell(:bassist)
        assert ! c.respond_to?(:in_view)

        setup_test_states_in(c)
        assert_equal "Cells rock.", c.render_state(:in_view, lambda{"Cells rock."})
      end
    end

    describe "#in_view" do
      it "execute the block in a real view" do
        content = "Cells rule."
        @test.setup
        assert_equal("<h1>Cells rule.</h1>", @test.in_view(:bassist) do content_tag("h1", content) end)
      end
    end
  end
end
