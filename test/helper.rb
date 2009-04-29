require File.expand_path(File.join(File.dirname(__FILE__), '../../../../test/test_helper'))

$LOAD_PATH.push File.dirname(__FILE__) + '/../../will_paginate/lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/../../will_paginate_liquidized/lib'

require 'will_paginate/core_ext'
require 'will_paginate/view_helpers'
require 'will_paginate/liquidized'
require 'will_paginate/liquidized/view_helpers'

WillPaginate.send :include, WillPaginate::Liquidized
Liquid::Template.register_filter(WillPaginate::Liquidized::ViewHelpers)

require 'action_view/helpers/tag_helper'
include ActionView::Helpers::TagHelper

module Test
  module Unit
    module Assertions
        include Liquid
        def assert_template_result(expected, template, assigns={}, message=nil)
          ActionController::Base.class_eval { attr_accessor :url } 
          @controller = BlogsController.new 
          @request = ActionController::TestRequest.new
          @controller.params = {:controller => 'blogs', :action => 'index'}
          @controller.request = @request
          @controller.url = ActionController::UrlRewriter.new(@request, nil)
          assert_equal expected, Liquid::Template.parse(template).render(assigns, :registers => {:controller => @controller})
        end 
    end
  end
end