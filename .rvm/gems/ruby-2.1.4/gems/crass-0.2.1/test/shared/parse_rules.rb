# encoding: utf-8

# Includes tests based on Simon Sapin's CSS parsing tests:
# https://github.com/SimonSapin/css-parsing-tests/

shared_tests_for 'parsing a list of rules' do
  it 'should parse an empty stylesheet' do
    assert_equal([], parse(''))
    assert_equal([], parse('foo'))
    assert_equal([], parse('foo 4'))
  end

  describe 'should parse an at-rule' do
    describe 'without a block' do
      it 'without a prelude' do
        tree = parse('@foo')
        rule = tree[0]

        assert_equal(1, tree.size)
        assert_equal(:at_rule, rule[:node])
        assert_equal("foo", rule[:name])
        assert_equal([], rule[:prelude])
        assert_tokens("@foo", rule[:tokens])
      end

      it 'with a prelude followed by a comment' do
        tree = parse("@foo bar; \t/* comment */")
        rule = tree[0]

        assert_equal(2, tree.size)
        assert_equal(:at_rule, rule[:node])
        assert_equal("foo", rule[:name])
        assert_tokens(" bar", rule[:prelude], 4)
        assert_tokens("@foo bar;", rule[:tokens])
        assert_tokens(" \t", tree[1], 9)
      end

      it 'with a prelude followed by a comment, when :preserve_comments == true' do
        options = {:preserve_comments => true}
        tree    = parse("@foo bar; \t/* comment */", options)
        rule    = tree[0]

        assert_equal(3, tree.size)
        assert_equal(:at_rule, rule[:node])
        assert_equal("foo", rule[:name])
        assert_tokens(" bar", rule[:prelude], 4, options)
        assert_tokens("@foo bar;", rule[:tokens], 0, options)
        assert_tokens(" \t", tree[1], 9, options)
        assert_tokens("/* comment */", tree[2], 11, options)
      end

      it 'with a prelude containing a simple block' do
        tree = parse("@foo [ bar")
        rule = tree[0]

        assert_equal(1, tree.size)
        assert_equal(:at_rule, rule[:node])
        assert_equal("foo", rule[:name])
        assert_tokens("@foo [ bar", rule[:tokens])

        prelude = rule[:prelude]
        assert_equal(2, prelude.size)
        assert_tokens(" ", prelude[0], 4)

        block = prelude[1]
        assert_equal(:simple_block, block[:node])
        assert_equal("[", block[:start])
        assert_equal("]", block[:end])
        assert_tokens("[ bar", block[:tokens], 5)
        assert_tokens(" bar", block[:value], 6)
      end
    end

    describe 'with a block' do
      it 'unclosed' do
        tree = parse("@foo { bar")
        rule = tree[0]

        assert_equal(1, tree.size)
        assert_equal(:at_rule, rule[:node])
        assert_equal("foo", rule[:name])
        assert_tokens(" ", rule[:prelude], 4)
        assert_tokens("@foo { bar", rule[:tokens])

        block = rule[:block]
        assert_equal(:simple_block, block[:node])
        assert_equal("{", block[:start])
        assert_equal("}", block[:end])
        assert_tokens("{ bar", block[:tokens], 5)
        assert_tokens(" bar", block[:value], 6)
      end

      it 'unclosed, preceded by a comment' do
        tree = parse(" /**/ @foo bar{[(4")
        rule = tree[2]

        assert_equal(3, tree.size)
        assert_tokens(" /**/ ", tree[0..1])
        assert_equal(:at_rule, rule[:node])
        assert_equal("foo", rule[:name])
        assert_tokens(" bar", rule[:prelude], 10)
        assert_tokens("@foo bar{[(4", rule[:tokens], 6)

        block = rule[:block]
        assert_equal(:simple_block, block[:node])
        assert_equal("{", block[:start])
        assert_equal("}", block[:end])
        assert_tokens("{[(4", block[:tokens], 14)
        assert_equal(1, block[:value].size)

        block = block[:value].first
        assert_equal(:simple_block, block[:node])
        assert_equal("[", block[:start])
        assert_equal("]", block[:end])
        assert_tokens("[(4", block[:tokens], 15)
        assert_equal(1, block[:value].size)

        block = block[:value].first
        assert_equal(:simple_block, block[:node])
        assert_equal("(", block[:start])
        assert_equal(")", block[:end])
        assert_tokens("(4", block[:tokens], 16)
        assert_tokens("4", block[:value], 17)
      end

      it 'unclosed, preceded by a comment, when :preserve_comments == true' do
        options = {:preserve_comments => true}
        tree    = parse(" /**/ @foo bar{[(4", options)
        rule    = tree[3]

        assert_equal(4, tree.size)
        assert_tokens(" /**/ ", tree[0..2], 0, options)

        assert_equal(:at_rule, rule[:node])
        assert_equal("foo", rule[:name])
        assert_tokens(" bar", rule[:prelude], 10, options)
        assert_tokens("@foo bar{[(4", rule[:tokens], 6, options)

        block = rule[:block]
        assert_equal(:simple_block, block[:node])
        assert_equal("{", block[:start])
        assert_equal("}", block[:end])
        assert_tokens("{[(4", block[:tokens], 14, options)
        assert_equal(1, block[:value].size)

        block = block[:value].first
        assert_equal(:simple_block, block[:node])
        assert_equal("[", block[:start])
        assert_equal("]", block[:end])
        assert_tokens("[(4", block[:tokens], 15, options)
        assert_equal(1, block[:value].size)

        block = block[:value].first
        assert_equal(:simple_block, block[:node])
        assert_equal("(", block[:start])
        assert_equal(")", block[:end])
        assert_tokens("(4", block[:tokens], 16, options)
        assert_tokens("4", block[:value], 17, options)
      end

    end
  end

  describe 'should parse a style rule' do
    it 'with preceding comment, selector, block, comment' do
      tree = parse(" /**/ div > p { color: #aaa;  } /**/ ")

      assert_equal(5, tree.size)
      assert_tokens(" /**/ ", tree[0..1])
      assert_tokens(" /**/ ", tree[3..4], 31)

      rule = tree[2]
      assert_equal(:style_rule, rule[:node])

      selector = rule[:selector]
      assert_equal(:selector, selector[:node])
      assert_equal("div > p", selector[:value])
      assert_tokens("div > p ", selector[:tokens], 6)

      children = rule[:children]
      assert_equal(3, children.size)
      assert_tokens(" ", children[0], 15)
      assert_tokens("  ", children[2], 28)

      property = children[1]
      assert_equal(:property, property[:node])
      assert_equal("color", property[:name])
      assert_equal("#aaa", property[:value])
      assert_equal(false, property[:important])
      assert_tokens("color: #aaa;", property[:tokens], 16)

      assert_equal([
        {:node=>:whitespace, :pos=>22, :raw=>" "},
        {:node=>:hash, :pos=>23, :raw=>"#aaa", :type=>:id, :value=>"aaa"},
      ], property[:children])
    end

    it 'with preceding comment, selector, block, comment, when :preserve_comments == true' do
      options = {:preserve_comments => true}
      tree    = parse(" /**/ div > p { color: #aaa;  } /**/ ", options)

      assert_equal(7, tree.size)
      assert_tokens(" /**/ ", tree[0..2], 0, options)
      assert_tokens(" /**/ ", tree[4..6], 31, options)

      rule = tree[3]
      assert_equal(:style_rule, rule[:node])

      selector = rule[:selector]
      assert_equal(:selector, selector[:node])
      assert_equal("div > p", selector[:value])
      assert_tokens("div > p ", selector[:tokens], 6, options)

      children = rule[:children]
      assert_equal(3, children.size)
      assert_tokens(" ", children[0], 15, options)
      assert_tokens("  ", children[2], 28, options)

      property = children[1]
      assert_equal(:property, property[:node])
      assert_equal("color", property[:name])
      assert_equal("#aaa", property[:value])
      assert_equal(false, property[:important])
      assert_tokens("color: #aaa;", property[:tokens], 16, options)

      assert_equal([
        {:node=>:whitespace, :pos=>22, :raw=>" "},
        {:node=>:hash, :pos=>23, :raw=>"#aaa", :type=>:id, :value=>"aaa"}
      ], property[:children])
    end

    it 'unclosed, with preceding comment, no selector' do
      tree = parse(" /**/ { color: #aaa  ")

      assert_equal(3, tree.size)
      assert_tokens(" /**/ ", tree[0..1])

      rule = tree[2]
      assert_equal(:style_rule, rule[:node])

      selector = rule[:selector]
      assert_equal(:selector, selector[:node])
      assert_equal("", selector[:value])
      assert_equal([], selector[:tokens])

      children = rule[:children]
      assert_equal(2, children.size)
      assert_tokens(" ", children[0], 7)

      property = children[1]
      assert_equal(:property, property[:node])
      assert_equal("color", property[:name])
      assert_equal("#aaa", property[:value])
      assert_equal(false, property[:important])
      assert_tokens("color: #aaa  ", property[:tokens], 8)

      assert_equal([
        {:node=>:whitespace, :pos=>14, :raw=>" "},
        {:node=>:hash, :pos=>15, :raw=>"#aaa", :type=>:id, :value=>"aaa"},
        {:node=>:whitespace, :pos=>19, :raw=>"  "}
      ], property[:children])
    end

    it 'unclosed, with preceding comment, no selector, when :preserve_comments == true' do
      options = {:preserve_comments => true}
      tree    = parse(" /**/ { color: #aaa  ", options)

      assert_equal(4, tree.size)
      assert_tokens(" /**/ ", tree[0..2], 0, options)

      rule = tree[3]
      assert_equal(:style_rule, rule[:node])

      selector = rule[:selector]
      assert_equal(:selector, selector[:node])
      assert_equal("", selector[:value])
      assert_equal([], selector[:tokens])

      children = rule[:children]
      assert_equal(2, children.size)
      assert_tokens(" ", children[0], 7, options)

      property = children[1]
      assert_equal(:property, property[:node])
      assert_equal("color", property[:name])
      assert_equal("#aaa", property[:value])
      assert_equal(false, property[:important])
      assert_tokens("color: #aaa  ", property[:tokens], 8, options)

      assert_equal([
        {:node=>:whitespace, :pos=>14, :raw=>" "},
        {:node=>:hash, :pos=>15, :raw=>"#aaa", :type=>:id, :value=>"aaa"},
        {:node=>:whitespace, :pos=>19, :raw=>"  "}
      ], property[:children])
    end
  end

  it 'should parse multiple style rules' do
    tree = parse("div { color: #aaa; } p{}")

    assert_equal(3, tree.size)

    rule = tree[0]
    assert_equal(:style_rule, rule[:node])

    selector = rule[:selector]
    assert_equal(:selector, selector[:node])
    assert_equal("div", selector[:value])
    assert_tokens("div ", selector[:tokens])

    children = rule[:children]
    assert_equal(3, children.size)
    assert_tokens(" ", children[0], 5)
    assert_tokens(" ", children[2], 18)

    prop = children[1]
    assert_equal(:property, prop[:node])
    assert_equal("color", prop[:name])
    assert_equal("#aaa", prop[:value])
    assert_equal(false, prop[:important])
    assert_tokens("color: #aaa;", prop[:tokens], 6)

    assert_equal([
      {:node=>:whitespace, :pos=>12, :raw=>" "},
      {:node=>:hash, :pos=>13, :raw=>"#aaa", :type=>:id, :value=>"aaa"}
    ], prop[:children])

    assert_tokens(" ", tree[1], 20)

    rule = tree[2]
    assert_equal(:style_rule, rule[:node])

    selector = rule[:selector]
    assert_equal(:selector, selector[:node])
    assert_equal("p", selector[:value])
    assert_tokens("p", selector[:tokens], 21)
  end

  it 'should ignore a block-less selector following a selector-less style rule' do
    tree = parse("{}a")
    assert_equal(1, tree.size)

    rule = tree[0]
    assert_equal(:style_rule, rule[:node])
    assert_equal([], rule[:children])

    selector = rule[:selector]
    assert_equal(:selector, selector[:node])
    assert_equal("", selector[:value])
    assert_equal([], selector[:tokens])
  end

  it 'should handle an at-rule following a selector-less style rule' do
    tree = parse("{}@a")
    assert_equal(2, tree.size)

    rule = tree[0]
    assert_equal(:style_rule, rule[:node])
    assert_equal([], rule[:children])

    selector = rule[:selector]
    assert_equal(:selector, selector[:node])
    assert_equal("", selector[:value])
    assert_equal([], selector[:tokens])

    rule = tree[1]
    assert_equal(:at_rule, rule[:node])
    assert_equal("a", rule[:name])
    assert_equal([], rule[:prelude])
    assert_tokens("@a", rule[:tokens], 2)
  end

  it 'should parse property values containing functions' do
    tree = parse("p:before { content: a\\ttr(data-foo) \" \"; }")

    assert_equal([
      {:node=>:style_rule,
       :selector=>
        {:node=>:selector,
         :value=>"p:before",
         :tokens=>
          [{:node=>:ident, :pos=>0, :raw=>"p", :value=>"p"},
           {:node=>:colon, :pos=>1, :raw=>":"},
           {:node=>:ident, :pos=>2, :raw=>"before", :value=>"before"},
           {:node=>:whitespace, :pos=>8, :raw=>" "}]},
       :children=>
        [{:node=>:whitespace, :pos=>10, :raw=>" "},
         {:node=>:property,
          :name=>"content",
          :value=>"attr(data-foo) \" \"",
          :important=>false,
          :children=>
           [{:node=>:whitespace, :pos=>19, :raw=>" "},
            {:node=>:function,
             :name=>"attr",
             :value=>
              [{:node=>:ident, :pos=>26, :raw=>"data-foo", :value=>"data-foo"}],
             :tokens=>
              [{:node=>:function, :pos=>20, :raw=>"a\\ttr(", :value=>"attr"},
               {:node=>:ident, :pos=>26, :raw=>"data-foo", :value=>"data-foo"},
               {:node=>:")", :pos=>34, :raw=>")"}]},
            {:node=>:whitespace, :pos=>35, :raw=>" "},
            {:node=>:string, :pos=>36, :raw=>"\" \"", :value=>" "}],
          :tokens=>
           [{:node=>:ident, :pos=>11, :raw=>"content", :value=>"content"},
            {:node=>:colon, :pos=>18, :raw=>":"},
            {:node=>:whitespace, :pos=>19, :raw=>" "},
            {:node=>:function,
             :name=>"attr",
             :value=>
              [{:node=>:ident, :pos=>26, :raw=>"data-foo", :value=>"data-foo"}],
             :tokens=>
              [{:node=>:function, :pos=>20, :raw=>"a\\ttr(", :value=>"attr"},
               {:node=>:ident, :pos=>26, :raw=>"data-foo", :value=>"data-foo"},
               {:node=>:")", :pos=>34, :raw=>")"}]},
            {:node=>:whitespace, :pos=>35, :raw=>" "},
            {:node=>:string, :pos=>36, :raw=>"\" \"", :value=>" "},
            {:node=>:semicolon, :pos=>39, :raw=>";"}]},
         {:node=>:whitespace, :pos=>40, :raw=>" "}]}
      ], tree)
  end

  it 'should parse property values containing nested functions' do
    tree = parse("div { width: e\\78 pression(alert(1)); }")

    assert_equal([
      {:node=>:style_rule,
       :selector=>
        {:node=>:selector,
         :value=>"div",
         :tokens=>
          [{:node=>:ident, :pos=>0, :raw=>"div", :value=>"div"},
           {:node=>:whitespace, :pos=>3, :raw=>" "}]},
       :children=>
        [{:node=>:whitespace, :pos=>5, :raw=>" "},
         {:node=>:property,
          :name=>"width",
          :value=>"expression(alert(1))",
          :important=>false,
          :children=>
           [{:node=>:whitespace, :pos=>12, :raw=>" "},
            {:node=>:function,
             :name=>"expression",
             :value=>
              [{:node=>:function,
                :name=>"alert",
                :value=>
                 [{:node=>:number,
                   :pos=>33,
                   :raw=>"1",
                   :repr=>"1",
                   :type=>:integer,
                   :value=>1}],
                :tokens=>
                 [{:node=>:function, :pos=>27, :raw=>"alert(", :value=>"alert"},
                  {:node=>:number,
                   :pos=>33,
                   :raw=>"1",
                   :repr=>"1",
                   :type=>:integer,
                   :value=>1},
                  {:node=>:")", :pos=>34, :raw=>")"}]}],
             :tokens=>
              [{:node=>:function,
                :pos=>13,
                :raw=>"e\\78 pression(",
                :value=>"expression"},
               {:node=>:function, :pos=>27, :raw=>"alert(", :value=>"alert"},
               {:node=>:number,
                :pos=>33,
                :raw=>"1",
                :repr=>"1",
                :type=>:integer,
                :value=>1},
               {:node=>:")", :pos=>34, :raw=>")"},
               {:node=>:")", :pos=>35, :raw=>")"}]}],
          :tokens=>
           [{:node=>:ident, :pos=>6, :raw=>"width", :value=>"width"},
            {:node=>:colon, :pos=>11, :raw=>":"},
            {:node=>:whitespace, :pos=>12, :raw=>" "},
            {:node=>:function,
             :name=>"expression",
             :value=>
              [{:node=>:function,
                :name=>"alert",
                :value=>
                 [{:node=>:number,
                   :pos=>33,
                   :raw=>"1",
                   :repr=>"1",
                   :type=>:integer,
                   :value=>1}],
                :tokens=>
                 [{:node=>:function, :pos=>27, :raw=>"alert(", :value=>"alert"},
                  {:node=>:number,
                   :pos=>33,
                   :raw=>"1",
                   :repr=>"1",
                   :type=>:integer,
                   :value=>1},
                  {:node=>:")", :pos=>34, :raw=>")"}]}],
             :tokens=>
              [{:node=>:function,
                :pos=>13,
                :raw=>"e\\78 pression(",
                :value=>"expression"},
               {:node=>:function, :pos=>27, :raw=>"alert(", :value=>"alert"},
               {:node=>:number,
                :pos=>33,
                :raw=>"1",
                :repr=>"1",
                :type=>:integer,
                :value=>1},
               {:node=>:")", :pos=>34, :raw=>")"},
               {:node=>:")", :pos=>35, :raw=>")"}]},
            {:node=>:semicolon, :pos=>36, :raw=>";"}]},
         {:node=>:whitespace, :pos=>37, :raw=>" "}]}
    ], tree)
  end
end
