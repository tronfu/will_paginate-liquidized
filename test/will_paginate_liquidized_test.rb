require File.dirname(__FILE__) + '/helper'

ActiveSupport::Deprecation.silenced = true

class WillPaginateLiquidizedTest < Test::Unit::TestCase
  def setup
    @blogs = (1..11).to_a.paginate :page => 1, :per_page => 4
  end  
  
  def test_collection_to_liquid_should_return_drop
    assert_equal WillPaginate::Liquidized::CollectionDrop, @blogs.to_liquid.class
  end
  
  def test_collection_drop_should_allow_access_to_collection_methods
    [:current_page, :per_page, :total_entries, :total_pages, :offset, 
     :previous_page, :next_page, :empty?, :length ].each do |method|
       assert_nothing_raised { @blogs.send method }
    end
    assert_nothing_raised { @blogs.sort_by do 1 end }
  end
  
  def test_should_allow_array_access
    assert_nothing_raised { assert_equal 1, @blogs[0] }
  end
  
  def test_render
    template = '{{ blogs | will_paginate_liquid }}'
    assigns  = { 'blogs' => @blogs }
    expected = "<div class=\"pagination\"><span class=\"disabled prev_page\">&laquo; Previous</span> <span class=\"current\">1</span> <a href=\"http://test.host/blogs/page/2\" rel=\"next\">2</a> <a href=\"http://test.host/blogs/page/3\">3</a> <a href=\"http://test.host/blogs/page/2\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div>"
    assert_template_result expected, template, assigns
  end
  
  def test_should_respect_assigned_will_paginate_options
    template = '{{ blogs | will_paginate_liquid }}'
    assigns  = {'blogs' => @blogs, 'will_paginate_options' => {:path => '/blogs', :class => 'will_paginate'}}
    expected = "<div class=\"will_paginate\" path=\"/blogs\"><span class=\"disabled prev_page\">&laquo; Previous</span> <span class=\"current\">1</span> <a href=\"http://test.host/blogs/page/2\" rel=\"next\">2</a> <a href=\"http://test.host/blogs/page/3\">3</a> <a href=\"http://test.host/blogs/page/2\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div>"
    assert_template_result expected, template, assigns
  end
  
  def test_should_respect_assigned_will_paginate_option_param_name
    template = '{{ blogs | will_paginate_liquid }}'    
    assigns  = {'blogs' => @blogs, 'will_paginate_options' => {:path => '/blogs', :param_name => 'p'}}
    expected = "<div class=\"pagination\" path=\"/blogs\"><span class=\"disabled prev_page\">&laquo; Previous</span> <span class=\"current\">1</span> <a href=\"http://test.host/blogs?p=2\" rel=\"next\">2</a> <a href=\"http://test.host/blogs?p=3\">3</a> <a href=\"http://test.host/blogs?p=2\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div>"
    assert_template_result expected, template, assigns
  end
end