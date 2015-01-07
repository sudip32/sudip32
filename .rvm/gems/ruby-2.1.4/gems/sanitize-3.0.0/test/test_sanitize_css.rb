# encoding: utf-8
require_relative 'common'

describe 'Sanitize::CSS' do
  make_my_diffs_pretty!
  parallelize_me!

  describe 'instance methods' do
    before do
      @default = Sanitize::CSS.new
      @relaxed = Sanitize::CSS.new(Sanitize::Config::RELAXED[:css])
      @custom  = Sanitize::CSS.new(:properties => %w[background color width])
    end

    describe '#properties' do
      it 'should sanitize CSS properties' do
        css = 'background: #fff; width: expression(alert("hi"));'

        @default.properties(css).must_equal ' '
        @relaxed.properties(css).must_equal 'background: #fff; '
        @custom.properties(css).must_equal 'background: #fff; '
      end

      it 'should allow whitelisted URL protocols' do
        [
          "background: url(relative.jpg)",
          "background: url('relative.jpg')",
          "background: url(http://example.com/http.jpg)",
          "background: url('ht\\tp://example.com/http.jpg')",
          "background: url(https://example.com/https.jpg)",
          "background: url('https://example.com/https.jpg')",
        ].each do |css|
          @default.properties(css).must_equal ''
          @relaxed.properties(css).must_equal css
          @custom.properties(css).must_equal ''
        end
      end

      it 'should not allow non-whitelisted URL protocols' do
        [
          "background: url(javascript:alert(0))",
          "background: url(ja\\56 ascript:alert(0))",
          "background: url('javascript:foo')",
          "background: url('ja\\56 ascript:alert(0)')",
          "background: url('ja\\va\\script\\:alert(0)')",
          "background: url('javas\\\ncript:alert(0)')",
          "background: url('java\\0script:foo')"
        ].each do |css|
          @default.properties(css).must_equal ''
          @relaxed.properties(css).must_equal ''
          @custom.properties(css).must_equal ''
        end
      end

      it 'should not allow -moz-binding' do
        css = "-moz-binding:url('http://ha.ckers.org/xssmoz.xml#xss')"

        @default.properties(css).must_equal ''
        @relaxed.properties(css).must_equal ''
        @custom.properties(css).must_equal ''
      end

      it 'should not allow expressions' do
        [
          "width:expression(alert(1))",
          "width:  /**/expression(alert(1)",
          "width:e\\78 pression(\n\nalert(\n1)",
          "width:\nexpression(alert(1));",
          "xss:expression(alert(1))",
          "height: foo(expression(alert(1)));"
        ].each do |css|
          @default.properties(css).must_equal ''
          @relaxed.properties(css).must_equal ''
          @custom.properties(css).must_equal ''
        end
      end

      it 'should not allow behaviors' do
        css = "behavior: url(xss.htc);"

        @default.properties(css).must_equal ''
        @relaxed.properties(css).must_equal ''
        @custom.properties(css).must_equal ''
      end

      describe 'when :allow_comments is true' do
        it 'should preserve comments' do
          @relaxed.properties('color: #fff; /* comment */ width: 100px;')
            .must_equal 'color: #fff; /* comment */ width: 100px;'

          @relaxed.properties("color: #fff; /* \n\ncomment */ width: 100px;")
            .must_equal "color: #fff; /* \n\ncomment */ width: 100px;"
        end
      end

      describe 'when :allow_comments is false' do
        it 'should strip comments' do
          @custom.properties('color: #fff; /* comment */ width: 100px;')
            .must_equal 'color: #fff;  width: 100px;'

          @custom.properties("color: #fff; /* \n\ncomment */ width: 100px;")
            .must_equal 'color: #fff;  width: 100px;'
        end
      end

      describe 'when :allow_hacks is true' do
        it 'should allow common CSS hacks' do
          @relaxed.properties('_border: 1px solid #fff; *width: 10px')
            .must_equal '_border: 1px solid #fff; *width: 10px'
        end
      end

      describe 'when :allow_hacks is false' do
        it 'should not allow common CSS hacks' do
          @custom.properties('_border: 1px solid #fff; *width: 10px')
            .must_equal ' '
        end
      end
    end

    describe '#stylesheet' do
      it 'should sanitize a CSS stylesheet' do
        css = %[
          /* Yay CSS! */
          .foo { color: #fff; }
          #bar { background: url(yay.jpg); }

          @media screen (max-width:480px) {
            .foo { width: 400px; }
            #bar:not(.baz) { height: 100px; }
          }
        ].strip

        @default.stylesheet(css).strip.must_equal %[
          .foo {  }
          #bar {  }
        ].strip

        @relaxed.stylesheet(css).must_equal css

        @custom.stylesheet(css).strip.must_equal %[
          .foo { color: #fff; }
          #bar {  }
        ].strip
      end

      describe 'when :allow_comments is true' do
        it 'should preserve comments' do
          @relaxed.stylesheet('.foo { color: #fff; /* comment */ width: 100px; }')
            .must_equal '.foo { color: #fff; /* comment */ width: 100px; }'

          @relaxed.stylesheet(".foo { color: #fff; /* \n\ncomment */ width: 100px; }")
            .must_equal ".foo { color: #fff; /* \n\ncomment */ width: 100px; }"
        end
      end

      describe 'when :allow_comments is false' do
        it 'should strip comments' do
          @custom.stylesheet('.foo { color: #fff; /* comment */ width: 100px; }')
            .must_equal '.foo { color: #fff;  width: 100px; }'

          @custom.stylesheet(".foo { color: #fff; /* \n\ncomment */ width: 100px; }")
            .must_equal '.foo { color: #fff;  width: 100px; }'
        end
      end

      describe 'when :allow_hacks is true' do
        it 'should allow common CSS hacks' do
          @relaxed.stylesheet('.foo { _border: 1px solid #fff; *width: 10px }')
            .must_equal '.foo { _border: 1px solid #fff; *width: 10px }'
        end
      end

      describe 'when :allow_hacks is false' do
        it 'should not allow common CSS hacks' do
          @custom.stylesheet('.foo { _border: 1px solid #fff; *width: 10px }')
            .must_equal '.foo {  }'
        end
      end
    end

    describe '#tree!' do
      it 'should sanitize a Crass CSS parse tree' do
        tree = Crass.parse("@import url(foo.css);\n" <<
          ".foo { background: #fff; font: 16pt 'Comic Sans MS'; }\n" <<
          "#bar { top: 125px; background: green; }")

        @custom.tree!(tree).must_be_same_as tree

        Crass::Parser.stringify(tree).must_equal "\n" <<
            ".foo { background: #fff;  }\n" <<
            "#bar {  background: green; }"
      end
    end
  end

  describe 'class methods' do
    describe '.properties' do
      it 'should call #properties' do
        Sanitize::CSS.stub_instance(:properties, proc {|css| css + 'bar' }) do
          Sanitize::CSS.properties('foo').must_equal 'foobar'
        end
      end
    end

    describe '.stylesheet' do
      it 'should call #stylesheet' do
        Sanitize::CSS.stub_instance(:stylesheet, proc {|css| css + 'bar' }) do
          Sanitize::CSS.stylesheet('foo').must_equal 'foobar'
        end
      end
    end

    describe '.tree!' do
      it 'should call #tree!' do
        Sanitize::CSS.stub_instance(:tree!, proc {|tree| tree + 'bar' }) do
          Sanitize::CSS.tree!('foo').must_equal 'foobar'
        end
      end
    end
  end
end
