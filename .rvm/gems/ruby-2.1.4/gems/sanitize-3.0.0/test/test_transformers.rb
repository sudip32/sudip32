# encoding: utf-8
require_relative 'common'

describe 'Transformers' do
  make_my_diffs_pretty!
  parallelize_me!

  youtube_transformer = lambda do |env|
    node      = env[:node]
    node_name = env[:node_name]

    # Don't continue if this node is already whitelisted or is not an element.
    return if env[:is_whitelisted] || !node.element?

    # Don't continue unless the node is an iframe.
    return unless node_name == 'iframe'

    # Verify that the video URL is actually a valid YouTube video URL.
    return unless node['src'] =~ %r|\A(?:https?:)?//(?:www\.)?youtube(?:-nocookie)?\.com/|

    # We're now certain that this is a YouTube embed, but we still need to run
    # it through a special Sanitize step to ensure that no unwanted elements or
    # attributes that don't belong in a YouTube embed can sneak in.
    Sanitize.node!(node, {
      :elements => %w[iframe],

      :attributes => {
        'iframe'  => %w[allowfullscreen frameborder height src width]
      }
    })

    # Now that we're sure that this is a valid YouTube embed and that there are
    # no unwanted elements or attributes hidden inside it, we can tell Sanitize
    # to whitelist the current node.
    {:node_whitelist => [node]}
  end

  it 'should receive a complete env Hash as input' do
    Sanitize.fragment('<SPAN>foo</SPAN>',
      :foo => :bar,
      :transformers => lambda {|env|
        return unless env[:node].element?

        env[:config][:foo].must_equal :bar
        env[:is_whitelisted].must_equal false
        env[:node].must_be_kind_of Nokogiri::XML::Node
        env[:node_name].must_equal 'span'
        env[:node_whitelist].must_be_kind_of Set
        env[:node_whitelist].must_be_empty
      }
    )
  end

  it 'should traverse all node types, including the fragment itself' do
    nodes = []

    Sanitize.fragment('<div>foo</div><!--bar--><script>cdata!</script>',
      :transformers => proc {|env| nodes << env[:node_name] }
    )

    nodes.must_equal %w[
      #document-fragment div text text text comment script text
    ]
  end

  it 'should perform top-down traversal' do
    nodes = []

    Sanitize.fragment('<div><span><strong>foo</strong></span><b></b></div><p>bar</p>',
      :transformers => proc {|env| nodes << env[:node_name] if env[:node].element? }
    )

    nodes.must_equal %w[div span strong b p]
  end

  it 'should whitelist nodes in the node whitelist' do
    Sanitize.fragment('<div class="foo">foo</div><span>bar</span>',
      :transformers => [
        proc {|env|
          {:node_whitelist => [env[:node]]} if env[:node_name] == 'div'
        },

        proc {|env|
          env[:is_whitelisted].must_equal false unless env[:node_name] == 'div'
          env[:is_whitelisted].must_equal true if env[:node_name] == 'div'
          env[:node_whitelist].must_include env[:node] if env[:node_name] == 'div'
        }
      ]
    ).must_equal '<div class="foo">foo</div>bar'
  end

  it 'should clear the node whitelist after each fragment' do
    called = false

    Sanitize.fragment('<div>foo</div>',
      :transformers => proc {|env| {:node_whitelist => [env[:node]]}}
    )

    Sanitize.fragment('<div>foo</div>',
      :transformers => proc {|env|
        called = true
        env[:is_whitelisted].must_equal false
        env[:node_whitelist].must_be_empty
      }
    )

    called.must_equal true
  end

  it 'should allow YouTube video embeds via the YouTube transformer' do
    input = '<iframe width="420" height="315" src="http://www.youtube.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen bogus="bogus"><script>alert()</script></iframe>'

    Sanitize.fragment(input, :transformers => youtube_transformer)
      .must_equal '<iframe width="420" height="315" src="http://www.youtube.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen="">&lt;script&gt;alert()&lt;/script&gt;</iframe>'
  end

  it 'should allow https YouTube video embeds via the YouTube transformer' do
    input = '<iframe width="420" height="315" src="https://www.youtube.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen bogus="bogus"><script>alert()</script></iframe>'

    Sanitize.fragment(input, :transformers => youtube_transformer)
      .must_equal '<iframe width="420" height="315" src="https://www.youtube.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen="">&lt;script&gt;alert()&lt;/script&gt;</iframe>'
  end

  it 'should allow protocol-relative YouTube video embeds via the YouTube transformer' do
    input = '<iframe width="420" height="315" src="//www.youtube.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen bogus="bogus"><script>alert()</script></iframe>'

    Sanitize.fragment(input, :transformers => youtube_transformer)
      .must_equal '<iframe width="420" height="315" src="//www.youtube.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen="">&lt;script&gt;alert()&lt;/script&gt;</iframe>'
  end

  it 'should allow privacy-enhanced YouTube video embeds via the YouTube transformer' do
    input = '<iframe width="420" height="315" src="https://www.youtube-nocookie.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen bogus="bogus"><script>alert()</script></iframe>'

    Sanitize.fragment(input, :transformers => youtube_transformer)
      .must_equal '<iframe width="420" height="315" src="https://www.youtube-nocookie.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen="">&lt;script&gt;alert()&lt;/script&gt;</iframe>'
  end

  it 'should not allow non-YouTube video embeds via the YouTube transformer' do
    input = '<iframe width="420" height="315" src="http://www.fake-youtube.com/embed/QH2-TGUlwu4" frameborder="0" allowfullscreen></iframe>'

    Sanitize.fragment(input, :transformers => youtube_transformer)
      .must_equal('')
  end
end
